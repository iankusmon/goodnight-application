#!/usr/bin/env bash
set -euo pipefail

BASE_URL="http://localhost:3000/api/v1"
USER1=1
USER2=2

echo "🚀 Demo Goodnight API Scenarios"
echo "==============================="

# Create test users with random names
RAND1=$RANDOM
RAND2=$RANDOM

echo
echo "🔹 Creating User 1 (id=1)..."
curl -s -w "\nHTTP %{http_code}\n" -X POST "$BASE_URL/users"   -H "Content-Type: application/json"   -d '{"id":1,"name":"Ryan C-'$RAND1'"}'

echo
echo "🔹 Creating User 2 (id=2)..."
curl -s -w "\nHTTP %{http_code}\n" -X POST "$BASE_URL/users"   -H "Content-Type: application/json"   -d '{"id":2,"name":"Ian K-'$RAND2'"}'

echo
echo "1. Clock In (User $USER1)"
curl -s -w "\nHTTP %{http_code}\n" -X POST "$BASE_URL/users/$USER1/sleep_sessions/clock_in"

echo
echo "2. Clock In again (should fail, expect 422)"
curl -s -w "\nHTTP %{http_code}\n" -X POST "$BASE_URL/users/$USER1/sleep_sessions/clock_in"

echo
echo "3. Clock Out (User $USER1)"
curl -s -w "\nHTTP %{http_code}\n" -X POST "$BASE_URL/users/$USER1/sleep_sessions/clock_out"

echo
echo "4. Clock Out again (should fail, expect 422)"
curl -s -w "\nHTTP %{http_code}\n" -X POST "$BASE_URL/users/$USER1/sleep_sessions/clock_out"

echo "5. List sessions (User $USER1)"
resp=$(mktemp)
status=$(curl -s -w "%{http_code}" -o "$resp" "$BASE_URL/users/$USER1/sleep_sessions")
echo "HTTP $status"
[ -s "$resp" ] && cat "$resp" | jq .
rm "$resp"


echo
echo "6. User $USER1 follows User $USER2"
curl -s -w "\nHTTP %{http_code}\n" -X POST "$BASE_URL/users/$USER1/follows"   -H "Content-Type: application/json"   -d '{"followed_id": '"$USER2"'}'

echo
echo "7. Try duplicate follow (should fail, expect 422)"
curl -s -w "\nHTTP %{http_code}\n" -X POST "$BASE_URL/users/$USER1/follows"   -H "Content-Type: application/json"   -d '{"followed_id": '"$USER2"'}'

echo
echo "8. Try self-follow (should fail, expect 422)"
curl -s -w "\nHTTP %{http_code}\n" -X POST "$BASE_URL/users/$USER1/follows"   -H "Content-Type: application/json"   -d '{"followed_id": '"$USER1"'}'

echo
echo "9. Unfollow User $USER2"
curl -s -w "\nHTTP %{http_code}\n" -X DELETE "$BASE_URL/users/$USER1/follows/$USER2"

echo
echo "10. Feed for User $USER1"
resp=$(mktemp)
status=$(curl -s -w "%{http_code}" -o "$resp" "$BASE_URL/users/$USER1/feed")
echo "HTTP $status"
[ -s "$resp" ] && cat "$resp" | jq .
rm "$resp"

# echo
# echo "11. Feed empty (User 99 has no follows)"
# resp=$(mktemp)
# status=$(curl -s -w "%{http_code}" -o "$resp" "$BASE_URL/users/99/feed")
# echo "HTTP $status"
# [ -s "$resp" ] && cat "$resp" | jq .
# rm "$resp"

echo
echo "Demo completed!"
