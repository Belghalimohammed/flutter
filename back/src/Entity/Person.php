<?php
namespace App\Entity;

use App\Repository\PersonRepository;
use Doctrine\ORM\Mapping as ORM;
use ApiPlatform\Metadata\ApiResource;



#[ORM\Entity(repositoryClass: PersonRepository::class)]
#[ApiResource]
class Person
{
    #[ORM\Id]
    #[ORM\GeneratedValue]
    #[ORM\Column(type: "integer")]
    private $id;

    #[ORM\Column(length:150, nullable:false)]
    private $firstName;

    #[ORM\Column(length:150, nullable:false)]
    private $familyName;

    #[ORM\Column(type: "integer")]
    private $age;

    #[ORM\Column(length:150, nullable:false)]
    private $url;

   

    public function __construct() {
       
    }

    public function getId() {
        return $this->id;
    }

      // Getter and setter for firstName
      public function getFirstName(): ?string
      {
          return $this->firstName;
      }
  
      public function setFirstName(string $firstName): self
      {
          $this->firstName = $firstName;
          return $this;
      }
  
      // Getter and setter for familyName
      public function getFamilyName(): ?string
      {
          return $this->familyName;
      }
  
      public function setFamilyName(string $familyName): self
      {
          $this->familyName = $familyName;
          return $this;
      }
  
      // Getter and setter for age
      public function getAge(): ?int
      {
          return $this->age;
      }
  
      public function setAge(int $age): self
      {
          $this->age = $age;
          return $this;
      }
  
      // Getter and setter for url
      public function getUrl(): ?string
      {
          return $this->url;
      }
  
      public function setUrl(string $url): self
      {
          $this->url = $url;
          return $this;
      }
   

}
