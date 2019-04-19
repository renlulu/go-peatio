package manager

import (
	"context"
	"fmt"
	"github.com/jinzhu/gorm"
)

type DBManager struct {
	User     string
	Password string
	DBName   string
	Engine   *gorm.DB
	Context  context.Context
}

func NewDBManager(user, password, db string, context context.Context) (*DBManager, error) {

	engine, err := gorm.Open("mysql", fmt.Sprintf("%s:%s@%s?charset=utf8", user, password, db))
	if err != nil {
		return nil, err
	}

	manager := &DBManager{
		User:     user,
		Password: password,
		DBName:   db,
		Engine:   engine,
		Context:  context,
	}

	return manager, nil
}
