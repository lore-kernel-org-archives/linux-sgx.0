Return-Path: <SRS0=nxNq=UC=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,T_DKIMWL_WL_HIGH autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC0A4C04AB5
	for <linux-sgx@archiver.kernel.org>; Mon,  3 Jun 2019 17:47:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7E6202705E
	for <linux-sgx@archiver.kernel.org>; Mon,  3 Jun 2019 17:47:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=tycho.nsa.gov header.i=@tycho.nsa.gov header.b="e7m7KjGV"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728287AbfFCRrc (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 3 Jun 2019 13:47:32 -0400
Received: from usfb19pa11.eemsg.mail.mil ([214.24.26.82]:50584 "EHLO
        USFB19PA11.eemsg.mail.mil" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725876AbfFCRrc (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Mon, 3 Jun 2019 13:47:32 -0400
X-EEMSG-check-017: 146585815|USFB19PA11_EEMSG_MP7.csd.disa.mil
Received: from emsm-gh1-uea10.ncsc.mil ([214.29.60.2])
  by USFB19PA11.eemsg.mail.mil with ESMTP/TLS/DHE-RSA-AES256-SHA256; 03 Jun 2019 17:47:14 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=tycho.nsa.gov; i=@tycho.nsa.gov; q=dns/txt;
  s=tycho.nsa.gov; t=1559584035; x=1591120035;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=D9rQ+Kb4wPjRxt8tnRaPTooSv6Yh0Ti/B5jMD7OS2rE=;
  b=e7m7KjGVbsxrAXbg16jCs1umZnkLRr7Vy5SQFtrk8JLLFfrfC8oyM79k
   MpT+CnmeIzZKhXbRS2p6kBbhGeKapB963tK+enPgHBFhj7nA8hIpbcR1P
   FAVrEjPn/JpRzbWoMayQXFS52X2GHFX4wRFnc2mhG808ED0Nuf6mrbssY
   lNRIel/ltXS4wf7/Q6wyU6TCHvkHHQAMZHvl1BHx+VTBKngWiQaKNkoxe
   Wa0p3VINgJ9qXfRIhtqKT+EIAU5HZt4j88Bj6cjOkiRNjdQrKzRZ5kvCR
   KfyPRBES/gSKX/KAMCfQblYtvh7Jt2WuYRbxXmDPnpW9oYehAc8nP0kxE
   w==;
X-IronPort-AV: E=Sophos;i="5.60,547,1549929600"; 
   d="scan'208";a="24342573"
IronPort-PHdr: =?us-ascii?q?9a23=3AoG1WUBwOGfTb++/XCy+O+j09IxM/srCxBDY+r6?=
 =?us-ascii?q?Qd0e0SKfad9pjvdHbS+e9qxAeQG9mCsrQd0LWd6vm5EUU7or+5+EgYd5JNUx?=
 =?us-ascii?q?JXwe43pCcHRPC/NEvgMfTxZDY7FskRHHVs/nW8LFQHUJ2mPw6arXK99yMdFQ?=
 =?us-ascii?q?viPgRpOOv1BpTSj8Oq3Oyu5pHfeQpFiCegbb9oMRm7owfcusYLjYd/N6o61w?=
 =?us-ascii?q?fErGZPd+lK321jOEidnwz75se+/Z5j9zpftvc8/MNeUqv0Yro1Q6VAADspL2?=
 =?us-ascii?q?466svrtQLeTQSU/XsTTn8WkhtTDAfb6hzxQ4r8vTH7tup53ymaINH2QLUpUj?=
 =?us-ascii?q?ms86tnVBnlgzocOjUn7G/YlNB/jKNDoBKguRN/xZLUYJqIP/Z6Z6/RYM8WSX?=
 =?us-ascii?q?ZEUstXWSNBGIe8ZJYRAeQHM+hTso3xq0IOoBa6AAWhAv7kxD1ViX/sxaA0zv?=
 =?us-ascii?q?ovEQ/G0gIjEdwBvnvbo9fpO6kdSu210KvFwC/fY/9K1zrw6o7FeQ0hr/GWWr?=
 =?us-ascii?q?JwdNLcx1QzFwzbllWQqZLqPzWI3eoQtmiU9e5gVeaxhG8ntgp8pSOvydo3io?=
 =?us-ascii?q?TSmoIUykzL9SV+wIovI924U1R0bcSrEJtXqSGXLo17Sd4hTWFwoCs217ILtJ?=
 =?us-ascii?q?GhcCUK1Zgr3QDTZvOZf4SS/x7uUvuaLy1ii3J/Yr2/gg6/8U2nyuLhSMa5yE?=
 =?us-ascii?q?1Kri9ZktnUsXANygDT5tCHSvRj+keh3i6C1xzJ5eFeIEA0iLHbJ4Q9wr8wip?=
 =?us-ascii?q?UTsUPDEjXwmErql6+Zal8o+u2p6+Tjernmp5mcOJFoigzmL6gjlcOyDf44Pw?=
 =?us-ascii?q?QTRWSX5+ux2KP58UHkWLlKi+c5kqjdsJDUP8Qboau5DhdO0ok+8BayFCum0d?=
 =?us-ascii?q?QEknkHK1JJYhSHj5PzNF3UL/D4Cum/j0y2kDh33/DGIqHhApLVI3ffjrjuYK?=
 =?us-ascii?q?x9609AxwYpwtFf5pRUCr4aLfLyXE/xqMLXDhsjPwOoxObnDc131pkCVmKXHq?=
 =?us-ascii?q?+ZLKTSvEeT5u0xOeaMYpUZuDTnJ/c55/7ul345mUQBfamuxZsXaG63Hu59I0?=
 =?us-ascii?q?WeZ3rhmdYBEWEWvgUgSOzmkkGNUTlWZ3yqRaIz+ik7CJ66DYfEXo2tgqaO3D?=
 =?us-ascii?q?24Hp1VYWBKEEuMHm3rd4WHWvcMbjydIsl6nzwAVLihTZIh1B60uA/7zbpnMv?=
 =?us-ascii?q?Tb+ikCuZ3/09h14vXZlQsu+jxsE8Sdz2aNQnlwnmMVWz8227tyoU9jxVeZ16?=
 =?us-ascii?q?h3nfhYGcZU5/NTXQcwLYTcwPBiC9DuRgLBec+ESFSjQtWhGzExVNMxw8QVbk?=
 =?us-ascii?q?Z7Adqiiw7M3yuwD78SjbyLC4Q+8rjA0HjpO8Z913HG2bE6j1Y4WMtPOnOpi7?=
 =?us-ascii?q?V/9wfJA47Jl0WYl6CweasA2y7N8X+JzXCSs0FATA5wTaLFUGgbZkvXq9T5+0?=
 =?us-ascii?q?zDQ6a1Cbs5LgRB1NSCKqpWatzplFlGQfDjN8nDY2K1hWi9HgiIxrySY4rwYW?=
 =?us-ascii?q?kd3zvSCFICkw8N+XaKLw8+Bj2uo2jGFjxhCUrvY1/w8el5sH67VlU7zxyOb0?=
 =?us-ascii?q?B6z7q64AMVhfiFR/MW2bIEvz0hpCtuEFmh2NLWDsKKpxB9c6VEfdM9/FBH2H?=
 =?us-ascii?q?rHuAxlJJOgNaFihkUFfgRvpUzuzRR3Cp5Ykcgutnwl0BR9Jbif0FNbeDOSxY?=
 =?us-ascii?q?rwNaHPKmnu4BCvbLbb2krA39aS+6cP7uk4qlr4sQG3GUot7W9n38NW03SC/J?=
 =?us-ascii?q?XKChQdUZbrXkYw7Rh6qKnQYjMh6IPMyX1sLa60vyfA2903GOslygygf9BEPa?=
 =?us-ascii?q?OKEw/yCdEaCNKoKOwrlFmldA4LPOdX9KQsJcOpa+OG2LK3POZnhD+pkH5I4J?=
 =?us-ascii?q?5j3U6W9ypzUOjI340bzPGexQaHVjH8jEu/vcDzg4xLeTYSHm+nwyj+GIFRfr?=
 =?us-ascii?q?FyfZoMCWq2P823ydF+hpH2Vn5c9V6jAU4G2NOzeRqVaVz93AJR2V4KrnO5gS?=
 =?us-ascii?q?G41SB7kyk1rqqD2yzD2/jidB0dOm5VXmZiiUrjIZOvgtAeXUioaRUplRS86U?=
 =?us-ascii?q?b0wKhbuaJ/IHTJTkdUfij2KGdiXrG3trqYbM5F8IkovjlPUOSgfVCaTabwox?=
 =?us-ascii?q?8b0yPlAmtfyyk3dzK0tZXjmRx1lmadIW1trHrWZ85w3w3T5N/CSv5L2DoJWi?=
 =?us-ascii?q?14hSPQBlimMNmj5c+UmIvbsuCiS2KhUYVecCbowI6Brya75nNlAQe5n/+tnt?=
 =?us-ascii?q?3rCw860TX019NyTyXHsA78YpX316S9Ke9nekhoBFnh68t1A41+iYQwhZ4L1H?=
 =?us-ascii?q?gEiZWa42AHnX3wMdpFw6L+amQCRToRz97S+gjl11VpLmiVyILhSnWd3sxhas?=
 =?us-ascii?q?GgbWMVwiI96ttHCKOV7LxCgCt0rUO0rQzWYfhgmDcS1OEh6GIbg+EOvgoh1C?=
 =?us-ascii?q?KdAqodHUNAJyzjiwyI78yirKVQfGuvd7iw1E1kndCkFr6CpBpRWGzndZg/HS?=
 =?us-ascii?q?9/9Nl/PEjQ333074HuYMPQYs4Lth2IjxfAiPBYKJQplvoPmSVoJXjyvXkhy+?=
 =?us-ascii?q?4miBxjxou6s5aaJGVt5q25HgRUOSHyZ8MW4jvtl7pRnt6K34CzGZVsAi4LU4?=
 =?us-ascii?q?XyTfKnDj0er+7oNgaJED0hrHeWArvfHQmD6Eh4q3LDCYykN3aSJHMB19VtWA?=
 =?us-ascii?q?GdJFBDgAATRDg6hZ45GRqqxcD7c0d2/CwR51/hphpN0O1oMhj/Un3EqQepbD?=
 =?us-ascii?q?c0VIaQLB5M4g5e4EfVNNSU7vhvECFA4p2hsAuNJ3SbZwtSDGEJRlaLB1f5Mr?=
 =?us-ascii?q?mu+NnP6e6YBuWlIvvPZ7WOtfJRV/OSyZ2z1Ytm+i6GNt+TMXl6E/07xk1DUG?=
 =?us-ascii?q?hjFMTfhjoPUS0XliLXY86ApBez5DN3ody/8Pv1XgLv5oyPBqBWMdVu/RC2nK?=
 =?us-ascii?q?iCO/SRhCZ/NTZXyJcMyWXUx7gY2V4YkztueCW1EbQcqS7NS7rdmqxNAB4acS?=
 =?us-ascii?q?9zL9VI4Lg83glLIsPbi9X11qJmgf4xEVtKSVvhmsSxb8wQP269LE/HBFqMNL?=
 =?us-ascii?q?mePjLL29r6brm4Sb1RkupUsR69tSyGHED9Jj6DjSXmVwizMeFQiyGWJB5euI?=
 =?us-ascii?q?amchZtEmXjTtXmaga7MN9rlz02wKU0hnfUOm4ALThwaURNrqef7SlAmPVwB3?=
 =?us-ascii?q?RB7mZ5LemDgyuZ7PPXKpcMvftrHyR7jeRa4HshxrtU6iFEWOJ6mC/IotFypF?=
 =?us-ascii?q?Gml/GFyiB7XxpWtjZLmIWLsF14OaXY6JZAX2rE/BAT4mWLEBkKqNxlCtrgu6?=
 =?us-ascii?q?BU1NfDjr78KDBH89jM58sTG9DUKN6bMHomKRfoFj/UDA8BTT6qL27fglZRn+?=
 =?us-ascii?q?2I+n2PqZg1sYbjmIASSr9AT1E1F/UaClh7E9wGOpt4QjQkkbuDhs4S+XW+tA?=
 =?us-ascii?q?XRRNldvp3fTvKSAfTvKDKYjblcfRcH2qn0LZgJNo36x0NtdkN1kZ/LG0rWQd?=
 =?us-ascii?q?BCvClhYhUor0VK9XgtBlE0jgjVawWipDc4GPKunxV8wl91bOg39Tyq81YxKX?=
 =?us-ascii?q?LLojc9lA86ntCzxXjbWz7rLbysWplWBjDvsE51eqj2SgA9T0f6yVdpPTGCRf?=
 =?us-ascii?q?Raj6FhbnxskA/Ro4BIH9ZdS7FJZFkbwvTBI70K2E5fqSLv/kZE5urDBJ0qwA?=
 =?us-ascii?q?kja52vqDRb0gFgbdg4I4TUJaxU3h5RgL6Dummj0eVnkyEEIENYy3+fYC4Fvg?=
 =?us-ascii?q?QzM7AiIye5trh35ReqhypIeG9KUeEj5P1t6BVuaKy70yv83usbeQiKPOuFIv?=
 =?us-ascii?q?bc4jWRmA=3D=3D?=
X-IPAS-Result: =?us-ascii?q?A2CKAQCvW/Vc/wHyM5BmGwEBAQEDAQEBBwMBAQGBZYFiB?=
 =?us-ascii?q?SqBOzOEPJNYAgaBECWJUJEICQEBAQEBAQEBATQBAgEBhEACgxIjOBMBAwEBA?=
 =?us-ascii?q?QQBAQEBAwEBbCiCOikBgmYBAQEBAyMEETQKAxALFQECAgImAgJXBgEMCAEBF?=
 =?us-ascii?q?4JIP4F3FKlNfjOFR4MigUaBDCiLWhd4gQeBEScMgl8+hB0Tgx6CWASNaYU1V?=
 =?us-ascii?q?JUHCYIPghiRFAYbgiKKc4lZjQCYLCGBWCsIAhgIIQ+DKIIaF448IwOBNgEBj?=
 =?us-ascii?q?WoBJYIsAQE?=
Received: from tarius.tycho.ncsc.mil ([144.51.242.1])
  by EMSM-GH1-UEA10.NCSC.MIL with ESMTP; 03 Jun 2019 17:47:13 +0000
Received: from moss-pluto.infosec.tycho.ncsc.mil (moss-pluto [192.168.25.131])
        by tarius.tycho.ncsc.mil (8.14.4/8.14.4) with ESMTP id x53Hl9Cl011449;
        Mon, 3 Jun 2019 13:47:10 -0400
Subject: Re: [RFC PATCH 0/9] security: x86/sgx: SGX vs. LSM
To:     "Xing, Cedric" <cedric.xing@intel.com>,
        "Christopherson, Sean J" <sean.j.christopherson@intel.com>,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     Andy Lutomirski <luto@kernel.org>,
        James Morris <jmorris@namei.org>,
        "Serge E . Hallyn" <serge@hallyn.com>,
        LSM List <linux-security-module@vger.kernel.org>,
        Paul Moore <paul@paul-moore.com>,
        Eric Paris <eparis@parisplace.org>,
        "selinux@vger.kernel.org" <selinux@vger.kernel.org>,
        Jethro Beekman <jethro@fortanix.com>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, X86 ML <x86@kernel.org>,
        "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "nhorman@redhat.com" <nhorman@redhat.com>,
        "npmccallum@redhat.com" <npmccallum@redhat.com>,
        "Ayoun, Serge" <serge.ayoun@intel.com>,
        "Katz-zamir, Shay" <shay.katz-zamir@intel.com>,
        "Huang, Haitao" <haitao.huang@intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        "Svahn, Kai" <kai.svahn@intel.com>, Borislav Petkov <bp@alien8.de>,
        Josh Triplett <josh@joshtriplett.org>,
        "Huang, Kai" <kai.huang@intel.com>,
        David Rientjes <rientjes@google.com>,
        "Roberts, William C" <william.c.roberts@intel.com>,
        "Tricca, Philip B" <philip.b.tricca@intel.com>
References: <20190531233159.30992-1-sean.j.christopherson@intel.com>
 <960B34DE67B9E140824F1DCDEC400C0F654EC5FD@ORSMSX116.amr.corp.intel.com>
From:   Stephen Smalley <sds@tycho.nsa.gov>
Message-ID: <e5e1dc77-eb56-bdab-8164-602ea544ea6e@tycho.nsa.gov>
Date:   Mon, 3 Jun 2019 13:47:09 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <960B34DE67B9E140824F1DCDEC400C0F654EC5FD@ORSMSX116.amr.corp.intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On 6/2/19 3:29 AM, Xing, Cedric wrote:
> Hi Sean,
> 
>> From: Christopherson, Sean J
>> Sent: Friday, May 31, 2019 4:32 PM
>>
>> This series is the result of a rather absurd amount of discussion over how to get SGX to play
>> nice with LSM policies, without having to resort to evil shenanigans or put undue burden on
>> userspace.  The discussion definitely wandered into completely insane territory at times, but
>> I think/hope we ended up with something reasonable.
>>
>> The basic gist of the approach is to require userspace to declare what protections are
>> maximally allowed for any given page, e.g. add a flags field for loading enclave pages that
>> takes ALLOW_{READ,WRITE,EXEC}.  LSMs can then adjust the allowed protections, e.g. clear
>> ALLOW_EXEC to prevent ever mapping the page with PROT_EXEC.  SGX enforces the allowed perms
>> via a new mprotect() vm_ops hook, e.g. like regular mprotect() uses MAY_{READ,WRITE,EXEC}.
>>
>> ALLOW_EXEC is used to deny hings like loading an enclave from a noexec file system or from a
>> file without EXECUTE permissions, e.g. without the ALLOW_EXEC concept, on SGX2 hardware
>> (regardless of kernel support) userspace could EADD from a noexec file using read-only
>> permissions, and later use mprotect() and ENCLU[EMODPE] to gain execute permissions.
>>
>> ALLOW_WRITE is used in conjuction with ALLOW_EXEC to enforce SELinux's EXECMOD (or EXECMEM).
>>
>> This is very much an RFC series.  It's only compile tested, likely has obvious bugs, the
>> SELinux patch could be completely harebrained, etc...
>> My goal at this point is to get feedback at a macro level, e.g. is the core concept
>> viable/acceptable, are there objection to hooking mprotect(), etc...
>>
>> Andy and Cedric, hopefully this aligns with your general expectations based on our last
>> discussion.
> 
> I couldn't understand the real intentions of ALLOW_* flags until I saw them in code. I have to say C is more expressive than English in that regard :)
> 
> Generally I agree with your direction but think ALLOW_* flags are completely internal to LSM because they can be both produced and consumed inside an LSM module. So spilling them into SGX driver and also user mode code makes the solution ugly and in some cases impractical because not every enclave host process has a priori knowledge on whether or not an enclave page would be EMODPE'd at runtime.
> 
> Theoretically speaking, what you really need is a per page flag (let's name it WRITTEN?) indicating whether a page has ever been written to (or more precisely, granted PROT_WRITE), which will be used to decide whether to grant PROT_EXEC when requested in future. Given the fact that all mprotect() goes through LSM and mmap() is limited to PROT_NONE, it's easy for LSM to capture that flag by itself instead of asking user mode code to provide it.
> 
> That said, here is the summary of what I think is a better approach.
> * In hook security_file_alloc(), if @file is an enclave, allocate some data structure to store for every page, the WRITTEN flag as described above. WRITTEN is cleared initially for all pages.
>    Open: Given a file of type struct file *, how to tell if it is an enclave (i.e. /dev/sgx/enclave)?
> * In hook security_mmap_file(), if @file is an enclave, make sure @prot can only be PROT_NONE. This is to force all protection changes to go through security_file_mprotect().
> * In the newly introduced hook security_enclave_load(), set WRITTEN for pages that are requested PROT_WRITE.
> * In hook security_file_mprotect(), if @vma->vm_file is an enclave, look up and use WRITTEN flags for all pages within @vma, along with other global flags (e.g. PROCESS__EXECMEM/FILE__EXECMOD in the case of SELinux) to decide on 
allowing/rejecting @prot.

At this point we have no knowledge of the source vma/file, right?  So 
what do we check FILE__EXECUTE and/or FILE__EXECMOD against? 
vma->vm_file at this point is /dev/sgx/enclave, right?

> * In hook security_file_free(), if @file is an enclave, free storage allocated for WRITTEN flags.
> 
> I'll try to make more detailed comments in my replies to individual patches sometime tomorrow.
> 
>>
>> Lastly, I added a patch to allow userspace to add multiple pages in a single ioctl().  It's
>> obviously not directly related to the security stuff, but the idea tangentially came up during
>> earlier discussions and it's something I think the UAPI should provide (it's a tiny change).
>> Since I was modifying the UAPI anyways, I threw it in.
>>
>> Sean Christopherson (9):
>>    x86/sgx: Remove unused local variable in sgx_encl_release()
>>    x86/sgx: Do not naturally align MAP_FIXED address
>>    x86/sgx: Allow userspace to add multiple pages in single ioctl()
>>    mm: Introduce vm_ops->mprotect()
>>    x86/sgx: Restrict mapping without an enclave page to PROT_NONE
>>    x86/sgx: Require userspace to provide allowed prots to ADD_PAGES
>>    x86/sgx: Enforce noexec filesystem restriction for enclaves
>>    LSM: x86/sgx: Introduce ->enclave_load() hook for Intel SGX
>>    security/selinux: Add enclave_load() implementation
>>
>>   arch/x86/include/uapi/asm/sgx.h        |  30 ++++--
>>   arch/x86/kernel/cpu/sgx/driver/ioctl.c | 143 +++++++++++++++++--------
>> arch/x86/kernel/cpu/sgx/driver/main.c  |  13 ++-
>>   arch/x86/kernel/cpu/sgx/encl.c         |  31 +++++-
>>   arch/x86/kernel/cpu/sgx/encl.h         |   4 +
>>   include/linux/lsm_hooks.h              |  16 +++
>>   include/linux/mm.h                     |   2 +
>>   include/linux/security.h               |   2 +
>>   mm/mprotect.c                          |  15 ++-
>>   security/security.c                    |   8 ++
>>   security/selinux/hooks.c               |  85 +++++++++++++++
>>   11 files changed, 290 insertions(+), 59 deletions(-)
>>
>> --
>> 2.21.0
> 
> -Cedric
> 

