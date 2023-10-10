# Build an array of exclude patterns
exclude_patterns=()
while IFS= read -r pattern; do
    exclude_patterns+=("$pattern")
done < <(find . -name "*.g.dart" | sed 's|^\./||')

# Now use the array when invoking lcov
lcov --remove coverage/lcov.info "${exclude_patterns[@]}" -o coverage/lcov.info