package manager

import (
	"context"
	"fmt"
	"github.com/go-xorm/xorm"
)

type DBManager struct {
	User     string
	Password string
	DBName   string
	engine   *xorm.Engine
	Context  context.Context
}

func NewDBManager(user, password, db string, context context.Context) (*DBManager, error) {
	engine, err := xorm.NewEngine("mysql", fmt.Sprintf("%s:%s@%s?charset=utf8", user, password, db))
	if err != nil {
		return nil, err
	}

	manager := &DBManager{
		User:     user,
		Password: password,
		DBName:   db,
		engine:   engine,
		Context:  context,
	}

	return manager, nil
}
