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
//  private def getAllIllness: IO[List[String]] = {
//    val query = sql"select name from  illness;"
//    query
//      .query[String] // This assumes that 'name' is of type String in the database
//      .to[List]
//      .transact(xa)
//  }
  //get illness by id
  private def getIllnessByID(id: Int): IO[Option[Illness]] = {
    val query = sql"select id, name, description from illness where id = $id"
    query
      .query[Illness]
      .option
      .transact(xa)
  }
  //using streams to retrieve data considerd best was as compared to list
  private val illnessStream = sql"select name from illness".query[String].stream.compile.toList.transact(xa)
  /*using
  --HC high level connection
  --HPV high level prepareds statement
  */

  def getPatientByLocation(location: String): IO[Option[Patients]] = {
    val queryString = sql"select ID,  name, age, location, email, password from patient where location = $location"
    queryString
      .query[Patients]
      .option
      .transact(xa)
  }

  //adding some highe level access using hpc and hp ...
  def getSymptomByName(name: String): IO[Option[Symptoms]] = {
    var stringQuery = sql"select id, name,  description from symptoms where name = ?"
    HC.stream[Symptoms](
      stringQuery[String],
      HPS.set(name),
      100
    ).compile.toList.map(_.headOption).transact(xa)
  }


  override def run(args: List[String]): IO[ExitCode] = getPatientByLocation("Chicago").debug.as(ExitCode.Success)

}
