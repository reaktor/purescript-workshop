module HackerReader.Styles where

import Prelude

import CSS (CSS, backgroundColor, display, fontSize, inline, inlineBlock, margin, marginLeft, marginRight, padding, paddingTop, px, rgb, white, width)
      
header :: CSS
header = do
  backgroundColor (rgb 255 102 0)
  margin (px 0.0) (px 0.0) (px 0.0) (px 0.0)
  padding (px 10.0) (px 10.0) (px 10.0) (px 10.0)
      
headerTitle :: CSS
headerTitle = do
  display inlineBlock
  margin (px 0.0) (px 0.0) (px 0.0) (px 0.0)
      
content :: CSS
content = do
  padding (px 10.0) (px 10.0) (px 10.0) (px 10.0)

filter :: CSS
filter = do
  marginLeft (px 20.0)
  width (px 200.0)
  fontSize (px 18.0)

rank :: CSS
rank = do
  display inline
  marginRight (px 4.0)

divider :: CSS
divider = do
  marginLeft (px 4.0)
  marginRight (px 4.0)
  
points :: CSS
points = do
  fontSize (px 12.0)
  paddingTop (px 2.0)
  display inline
  
author :: CSS
author = do
  fontSize (px 12.0)
  paddingTop (px 2.0)
  display inline
  
numComments :: CSS
numComments = do
  marginRight (px 5.0)
  fontSize (px 12.0)
  paddingTop (px 2.0)
  display inline

sort :: CSS
sort = do
  display inline
  fontSize (px 18.0)
  marginLeft (px 10.0)

selected :: CSS
selected = do
  display inline
  fontSize (px 18.0)
  marginLeft (px 10.0)
  padding (px 4.0) (px 4.0) (px 4.0) (px 4.0)
  backgroundColor white
      
unselected :: CSS
unselected = do
  display inline
  fontSize (px 18.0)
  marginLeft (px 10.0)
