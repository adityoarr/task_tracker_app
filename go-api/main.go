package main

import (
	"log"
	"net/http"

	"github.com/gin-contrib/cors"
	"github.com/gin-gonic/gin"
	"gorm.io/driver/sqlite"
	"gorm.io/gorm"
)

type Task struct {
	ID          uint   `gorm:"primaryKey" json:"id"`
	Title       string `json:"title" binding:"required"`
	Description string `json:"description"`
	Status      string `json:"status" gorm:"default:'Pending'"`
}

var db *gorm.DB

func initDB() {
	var err error
	// Menyimpan file database.db di root folder backend
	db, err = gorm.Open(sqlite.Open("database.db"), &gorm.Config{})
	if err != nil {
		log.Fatal("Gagal terkoneksi ke database SQLite")
	}
	db.AutoMigrate(&Task{})
}

func main() {
	initDB()
	r := gin.Default()

	// Mengizinkan koneksi dari Flutter emulator/device
	r.Use(cors.Default())

	r.GET("/tasks", func(c *gin.Context) {
		var tasks []Task
		db.Find(&tasks)
		c.JSON(http.StatusOK, tasks)
	})

	r.POST("/tasks", func(c *gin.Context) {
		var task Task
		if err := c.ShouldBindJSON(&task); err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
			return
		}
		db.Create(&task)
		c.JSON(http.StatusCreated, task)
	})

	r.PATCH("/tasks/:id/status", func(c *gin.Context) {
		id := c.Param("id")
		var input struct {
			Status string `json:"status" binding:"required"`
		}
		if err := c.ShouldBindJSON(&input); err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
			return
		}
		var task Task
		if err := db.First(&task, id).Error; err != nil {
			c.JSON(http.StatusNotFound, gin.H{"error": "Task tidak ditemukan"})
			return
		}
		db.Model(&task).Update("status", input.Status)
		c.JSON(http.StatusOK, task)
	})

	r.Run(":8080")
}