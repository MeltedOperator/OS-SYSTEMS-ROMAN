import hashlib, itertools, string
import multiprocessing, time, os, sys

CHARSET = string.ascii_lowercase  # Только a-z
MAX_LEN = 4

def worker(chunk, target_hash):
    pid = os.getpid()
    for candidate in chunk:
        if hashlib.md5(candidate.encode()).hexdigest() == target_hash:
            print(f"[PID {pid}] Найдено: '{candidate}'")
            return candidate
    return None

def generate_candidates():
    candidates = []
    for length in range(1, MAX_LEN + 1):
        for combo in itertools.product(CHARSET, repeat=length):
            candidates.append(''.join(combo))
    return candidates

def brute_force(target_hash, num_workers=None):
    if num_workers is None:
        num_workers = multiprocessing.cpu_count()
    
    print(f"Ищем MD5({target_hash[:8]}...)")
    start = time.time()
    candidates = generate_candidates()
    
    chunk_size = len(candidates) // num_workers
    chunks = [candidates[i*chunk_size:(i+1)*chunk_size] for i in range(num_workers)]
    if num_workers > 1:
        chunks[-1] = candidates[(num_workers-1)*chunk_size:]  # Последний чанк
    
    print(f"Воркеров: {num_workers}, кандидатов: {len(candidates):,}")
    
    with multiprocessing.Pool(num_workers) as pool:
        results = pool.starmap(worker, [(chunk, target_hash) for chunk in chunks])
    
    elapsed = time.time() - start
    found = next((r for r in results if r), None)
    
    if found:
        print(f" '{target_hash}' = '{found}' ({elapsed:.2f} сек)")
    else:
        print(f" Не найдено ({elapsed:.2f} сек)")

if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("Ошибка. Передайте хеш!")
        print("Пример: python3 cracker.py d077f244def8a70e5ea758bd8352fcd8")
        sys.exit(1)
    
    # Цикл по всем хешам из аргументов
    for hash_arg in sys.argv[1:]:
        print("\n" + "="*50)
        brute_force(hash_airg.strip())
