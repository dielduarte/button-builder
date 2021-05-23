@module("./App.module.css")
external styles: {..} = "default"

@react.component
let make = () => {
  <div className={styles["container"]}>
    <div className={styles["column"]}> <Button /> <Button /> </div> <Sidebar />
  </div>
}
