import Array;

array(string) split_string_to_ints(string s) {
    array(string) parts = map(s / " ", String.trim);
    return filter(parts, lambda(string x) { return x != ""; });
}

int to_int(string s) { return (int)s; }

bool is_safe(array(int) report) {
    if (sizeof(report) < 2) {
        return false;
    }

    bool isIncreasing = true;
    bool isDecreasing = true;

    for (int i = 1; i < sizeof(report); ++i) {
        int curr = report[i];
        int prev = report[i - 1];

        int diff = abs(curr - prev);
        if (diff < 1 || diff > 3) {
            return false;
        }

        if (curr > prev) {
            isDecreasing = false;
        } else if (curr < prev) {
            isIncreasing = false;
        }

        if (!isIncreasing && !isDecreasing) {
            return false;
        }
    }

    return true;
}

bool try_removing_one(array(int) report) {
    for (int i = 0; i < sizeof(report); ++i) {
        array(int) new_report = report[..i-1] + report[i+1..];

        if (sizeof(new_report) > 1 && is_safe(new_report)) {
            return true;
        }
    }

    return false;
}

array(int) count_safe_reports() {
    int part1_score = 0;
    int part2_score = 0;

    while (string line = Stdio.stdin.gets()) {
        line = String.trim(line);
        if (strlen(line) == 0) continue;

        array(int) report = map(split_string_to_ints(line), to_int);

        if (is_safe(report)) {
            part1_score++;
            part2_score++;
        } else if (try_removing_one(report)) {
            part2_score++;
        }

    }

    return ({ part1_score, part2_score });
}


int main() {
    array(int) scores = count_safe_reports();

    write("Part 1: %d\n", scores[0]);
    write("Part 2: %d\n", scores[1]);

    return 0;
}