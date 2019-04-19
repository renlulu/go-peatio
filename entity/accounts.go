package entity

import (
	"math/big"
	"time"
)


type Accounts struct {
	ID         int64     `gorm:"column:id;PRIMARY_KEY"`
	MemberId   int64     `gorm:"column:member_id"`
	CurrencyId string    `gorm:"column:currency_id"`
	Balance    big.Int   `gorm:"column:balance"`
	Locked     big.Int   `gorm:"column:locked"`
	CreatedAt  time.Time `gorm:"column:created_at"`
	UpdatedAt  time.Time `gorm:"column:updated_at"`
}
