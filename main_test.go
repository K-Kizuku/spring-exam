package main

import "testing"

func TestCheckParentheses(t *testing.T) {
	tests := []struct {
		name     string
		input    string
		expected bool
	}{
		{
			name:     "正常系：かっこの対応が取れている",
			input:    "((a)(b))",
			expected: true,
		},
		{
			name:     "正常系：空文字列",
			input:    "",
			expected: true,
		},
		{
			name:     "正常系：かっこを含まない",
			input:    "hoge",
			expected: true,
		},
		{
			name:     "異常系：閉じかっこが多い",
			input:    "(a)b)(c",
			expected: false,
		},
		{
			name:     "異常系：開きかっこが多い",
			input:    "(()",
			expected: false,
		},
		{
			name:     "異常系：かっこの順序が逆",
			input:    ")o(",
			expected: false,
		},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			actual := CheckParentheses(tt.input)
			if actual != tt.expected {
				t.Errorf("got: %v, want: %v", actual, tt.expected)
			}
		})
	}
}
