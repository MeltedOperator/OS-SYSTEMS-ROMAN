import hashlib

secret = "cat"  #3 символа — для теста
target_hash = hashlib.md5(secret.encode()).hexdigest()
print(f"Целевой хеш: {target_hash}")
