package main

import (
	"bufio"
	"fmt"
	"os"
	"strconv"
	"strings"
)

func clearScreen() {
	fmt.Print("\x1b[H\x1b[2J")
}

func waitEnter(reader *bufio.Reader) {
	fmt.Print("กด Enter เพื่อดำเนินการต่อ...")
	reader.ReadString('\n')
}

func main() {
	reader := bufio.NewReader(os.Stdin)
	step := 1

	for {
		clearScreen()

		if step == 1 {
			fmt.Println("-------------------------")
			fmt.Println("GL-Toolbox Version 1.0")
			fmt.Println("-------------------------")
			fmt.Println("[1] Tweak for gaming")
			fmt.Println("[2] Clear event logs")
			fmt.Println("")
			fmt.Print("Select : ")

			input, err := reader.ReadString('\n')
			if err != nil {
				fmt.Println("เกิดข้อผิดพลาดในการอ่านข้อมูล กรุณาลองใหม่")
				waitEnter(reader)
				continue
			}

			selectInput, err := strconv.Atoi(strings.TrimSpace(input))
			if err != nil {
				fmt.Println("not a number please try again .")
				waitEnter(reader)
				continue
			}

			if selectInput != 1 && selectInput != 2 {
				fmt.Println("กรุณาเลือก 1 หรือ 2 เท่านั้น")
				waitEnter(reader)
				continue
			}

			fmt.Println("select : ", selectInput)
			break
		}
	}
}