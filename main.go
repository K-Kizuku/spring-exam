package main

import (
	"bufio"
	"fmt"
	"os"
)

func main() {
	// 標準入力から1行読み込む
	s := readLine()
	// かっこの対応をチェック
	if CheckParentheses(s) {
		fmt.Println("OK")
	} else {
		fmt.Println("NG")
	}

}

// かっこ"()"の対応をチェックする関数
func CheckParentheses(s string) bool {
	// かっこの対応を確認するためのスタック
	stack := []rune{}
	// 入力文字列を1文字ずつチェック
	for _, c := range s {
		switch c {
		case '(':
			// 開きかっこの場合はスタックに追加
			stack = append(stack, c)
		case ')':
			// 閉じかっこの場合はスタックから1つ取り出す
			if len(stack) == 0 {
				// スタックが空の場合はかっこの対応が取れない
				return false
			}
			stack = stack[:len(stack)-1]
		}
	}
	// スタックが空であればかっこの対応が取れている
	return len(stack) == 0
}

var rdr = bufio.NewReaderSize(os.Stdin, 1000000)

func readLine() string {
	buf := make([]byte, 0, 1000000)
	for {
		l, p, err := rdr.ReadLine()
		if err != nil {
			panic(err)
		}
		buf = append(buf, l...)
		if !p {
			break
		}
	}
	return string(buf)
}
