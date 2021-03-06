<?php
namespace Codeception\PHPUnit\Constraint;

use Codeception\Util\Console\Message;

class Page extends \PHPUnit_Framework_Constraint_StringContains
{
    protected $uri;

    public function __construct($string, $uri = '')
    {
        $this->string     = (string)$string;
        $this->uri = $uri;
        $this->ignoreCase = true;
    }

    protected function matches($other)
    {
        if ($this->ignoreCase) {
            return mb_stripos($other, $this->string, 0, mb_detect_encoding($this->string)) !== FALSE;
        } else {
            return mb_strpos($other, $this->string, 0, mb_detect_encoding($this->string)) !== FALSE;
        }
    }

    protected function failureDescription($other)
    {
        $page = substr($other,0,300);
        $message = new Message($page);
        $message->style('info');
        $message->prepend($this->uriMessage());
        if (strlen($other) > 300) {
            $debugMessage = new Message("[Content too long to display. See complete response in '_log' directory]");
            $debugMessage->style('debug')->prepend("\n");
            $message->append($debugMessage);
        }
        $message->prepend("\n-->")->append("\n--> ");
        return $message->getMessage() . $this->toString();
    }

    protected function uriMessage($onPage = "")
    {
        if (!$this->uri) return "";
        $message = new Message($this->uri);
        $message->style('bold');
        $message->prepend(" $onPage ");
        return $message;
    }

}
