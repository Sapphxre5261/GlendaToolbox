package main

import (
	"bufio"
	"fmt"
	"os"
	"strings"
)

func main() {
	reader := bufio.NewReader(os.Stdin)

	// 1. ใช้ Print ไม่ขึ้นบรรทัดใหม่ เพื่อให้ผู้ใช้พิมพ์ต่อท้าย
	fmt.Print("ชื่อของคุณคืออะไร: ")
	nameInput, err := reader.ReadString('\n')
	if err != nil {
		fmt.Println("เกิดข้อผิดพลาดในการอ่านข้อมูล:", err)
		return
	}
	name := strings.TrimSpace(nameInput)

	// 2. ใช้ Println แสดงผลและขึ้นบรรทัดใหม่
	fmt.Printf("ยินดีต้อนรับ, %s!\n", name)

	// 3. ตัวอย่างลูปโต้ตอบคำสั่งจนกว่าจะพิมพ์ exit
	for {
		fmt.Print("พิมพ์คำสั่ง (หรือพิมพ์ exit เพื่อออก): ")
		cmdInput, err := reader.ReadString('\n')
		if err != nil {
			fmt.Println("อ่านคำสั่งไม่ได้:", err)
			break
		}

		cmd := strings.TrimSpace(cmdInput)
		if cmd == "exit" {
			fmt.Println("ออกจากโปรแกรมแล้ว")
			break
		}

		fmt.Printf("คุณพิมพ์คำสั่ง: %s\n", cmd)
	}
}