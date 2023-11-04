import cats.effect._
import cats.implicits._
import doobie._
import doobie.implicits._
import doobie.util.transactor.Transactor
// Very important to deal with arrays
import doobie.postgres._
import doobie.postgres.implicits._
import doobie.util.transactor.Transactor._

object Doobiez extends IOApp{
  //defining our case class vey importand for defining a data structure
  case class Patients(ID: Int, name: String, age: Int, location: String, email: String, password: String)
  case class Specialist(ID: Int, name: String, category: Int, location: String, email: String, availability: Int)
  case class Type(ID: Int, name: String)
  case class Symptoms(ID: Int, name: String, description: String)
  case class Illness(ID: Int, name: String, description: String)
  case class SubIllness(ID: Int, name: String, illness: Int)
  case class IllnessSymptoms(ID: Int, illness: Int, symptom: Int)
  case class Bill(ID: Int, patient: Int, amount: Float)

  //adding class debugger to help trace the error
  implicit class  Debugger[A](io: IO[A]){
    def debug: IO[A] = io.map { a =>
      println(s"${Thread.currentThread().getName} $a")
      a
    }

  }
  //define a transactors, a transactor enable us connect to the db and make queries(read write and update the db)
  val xa: Transactor[IO] = Transactor.fromDriverManager(
    "org.postgresql.Driver",
    "jdbc:postgresql:hospital",
    "docker", // username
    "docker" // password
  )

  //get all illness
  private def getAllIllness: IO[List[String]] = {
    val query = sql"select name from  illness;"
    query
      .query[String] // This assumes that 'name' is of type String in the database
      .to[List]
      .transact(xa)
  }
  //get illness by id
  private def getIllnessByID(id: Int): IO[Illness] = {
    val query = sql"select id, name, description from illness where id = $id"
    query
      .query[Illness]
      .unique
      .transact(xa)
  }



  override def run(args: List[String]): IO[ExitCode] = getIllnessByID(2).debug.as(ExitCode.Success)

}
