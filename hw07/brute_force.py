#!/usr/bin/env python3
import hashlib
import itertools
import multiprocessing
import os
import string
import sys
import time


CHARSET = string.ascii_lowercase
MAX_LEN = 4


def generate_candidates():
    candidates = []
    for length in range(1, MAX_LEN + 1):
        for combo in itertools.product(CHARSET, repeat=length):
            candidates.append("".join(combo))
    return candidates


def sequential_search(candidates, target_hash):
    start = time.perf_counter()
    checked = 0

    for candidate in candidates:
        if hashlib.md5(candidate.encode()).hexdigest() == target_hash:
            elapsed = time.perf_counter() - start
            speed = checked / elapsed if elapsed > 0 else 0
            return {
                "found": candidate,
                "checked": checked,
                "elapsed": elapsed,
                "speed": speed,
            }
        checked += 1

    elapsed = time.perf_counter() - start
    speed = checked / elapsed if elapsed > 0 else 0
    return {
        "found": None,
        "checked": checked,
        "elapsed": elapsed,
        "speed": speed,
    }


def worker(worker_id, chunk, target_hash, found_event, result_queue):
    pid = os.getpid()
    start = time.perf_counter()
    checked = 0

    for candidate in chunk:
        if found_event.is_set():
            break

        if hashlib.md5(candidate.encode()).hexdigest() == target_hash:
            elapsed = time.perf_counter() - start
            speed = checked / elapsed if elapsed > 0 else 0
            result_queue.put({
                "worker_id": worker_id,
                "pid": pid,
                "found": candidate,
                "checked": checked,
                "elapsed": elapsed,
                "speed": speed,
                "chunk_size": len(chunk),
            })
            found_event.set()
            return

        checked += 1

    elapsed = time.perf_counter() - start
    speed = checked / elapsed if elapsed > 0 else 0
    result_queue.put({
        "worker_id": worker_id,
        "pid": pid,
        "found": None,
        "checked": checked,
        "elapsed": elapsed,
        "speed": speed,
        "chunk_size": len(chunk),
    })


def multiprocessing_search(candidates, target_hash, num_workers):
    total = len(candidates)
    chunk_size = total // num_workers
    chunks = []

    for i in range(num_workers):
        lo = i * chunk_size
        hi = total if i == num_workers - 1 else (i + 1) * chunk_size
        chunks.append(candidates[lo:hi])

    manager = multiprocessing.Manager()
    found_event = manager.Event()
    result_queue = manager.Queue()

    start_total = time.perf_counter()

    processes = []
    for i, chunk in enumerate(chunks):
        p = multiprocessing.Process(
            target=worker,
            args=(i, chunk, target_hash, found_event, result_queue),
        )
        p.start()
        processes.append(p)

    for p in processes:
        p.join()

    elapsed_total = time.perf_counter() - start_total

    worker_results = []
    while not result_queue.empty():
        worker_results.append(result_queue.get())

    worker_results.sort(key=lambda x: x["worker_id"])

    found = next((r["found"] for r in worker_results if r["found"] is not None), None)

    return {
        "found": found,
        "elapsed_total": elapsed_total,
        "worker_results": worker_results,
        "chunks": [len(c) for c in chunks],
    }


def print_worker_table(seq_elapsed, mp_result):
    print()
    print("=== TABLE ===")
    print(f"{'workers':>7} {'worker':>7} {'candidates':>12} {'time':>10} {'speed':>12} {'vs seq':>10}")
    for r in mp_result["worker_results"]:
        speedup = seq_elapsed / r["elapsed"] if r["elapsed"] > 0 else 0
        print(
            f"{len(mp_result['chunks']):>7} "
            f"{r['worker_id']:>7} "
            f"{r['chunk_size']:>12} "
            f"{r['elapsed']:>10.2f}s "
            f"{r['speed']:>12.0f} "
            f"{speedup:>9.2f}x"
        )


def benchmark(target_hash, num_workers=None):
    if num_workers is None:
        num_workers = multiprocessing.cpu_count()

    candidates = generate_candidates()
    total = len(candidates)

    print(f"Target hash: {target_hash}")
    print(f"Candidates: {total:,}")
    print(f"Workers: {num_workers}")

    seq = sequential_search(candidates, target_hash)
    print()
    print("=== SEQUENTIAL ===")
    if seq["found"]:
        print(f"found: {seq['found']}")
    else:
        print("found: not found")
    print(f"time: {seq['elapsed']:.2f}s")
    print(f"speed: {seq['speed']:.0f} H/s")

    mp = multiprocessing_search(candidates, target_hash, num_workers)
    print()
    print("=== MULTIPROCESSING ===")
    if mp["found"]:
        print(f"found: {mp['found']}")
    else:
        print("found: not found")
    print(f"time: {mp['elapsed_total']:.2f}s")

    if mp["elapsed_total"] > 0:
        print(f"speedup total: {seq['elapsed'] / mp['elapsed_total']:.2f}x")

    print_worker_table(seq["elapsed"], mp)


def main():
    if len(sys.argv) < 2:
        print("Передайте аргумент: MD5-хеш")
        print(f"Пример: python3 {sys.argv[0]} 827ccb0eea8a706c4c34a16891f84e7b")
        sys.exit(1)

    for target_hash in sys.argv[1:]:
        print("\n" + "=" * 60)
        benchmark(target_hash.strip())


if __name__ == "__main__":
    main()
