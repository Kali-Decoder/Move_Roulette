import LaunchGameButton from "./LaunchGameButton";


export default function LetsPlaySection() {
  return (
    <section id="let'splay" className="items-center flex flex-col px-36 ">
      <div className="font-display flex text-white flex-col text-center items-center gap-4 my-[251px]">
        <h1 className="text-5xl">Let&apos;s play</h1>
        <h2 className="text-white uppercase" style={{wordSpacing:"8px"}}>Join us in the realm of gaming where every click opens up a world of <b>adventure</b> <br /> and <b>discovery</b>. Let&apos;s Play isn&apos;t just a destination; it&apos;s a gateway to <b>boundless</b> <br /> entertainment</h2>
        <div className="flex gap-8">
      
          <LaunchGameButton />
        </div>
      </div>
    </section>
  )
}