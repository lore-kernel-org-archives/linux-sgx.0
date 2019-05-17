Return-Path: <SRS0=W/GT=TR=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 37891C04E87
	for <linux-sgx@archiver.kernel.org>; Fri, 17 May 2019 18:05:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EAFC92168B
	for <linux-sgx@archiver.kernel.org>; Fri, 17 May 2019 18:05:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=tycho.nsa.gov header.i=@tycho.nsa.gov header.b="n6Pj6HCg"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726990AbfEQSFp (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 17 May 2019 14:05:45 -0400
Received: from usfb19pa13.eemsg.mail.mil ([214.24.26.84]:17024 "EHLO
        USFB19PA13.eemsg.mail.mil" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726422AbfEQSFp (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Fri, 17 May 2019 14:05:45 -0400
X-EEMSG-check-017: 263367335|USFB19PA13_EEMSG_MP9.csd.disa.mil
Received: from emsm-gh1-uea11.ncsc.mil ([214.29.60.3])
  by USFB19PA13.eemsg.mail.mil with ESMTP/TLS/DHE-RSA-AES256-SHA256; 17 May 2019 18:05:42 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=tycho.nsa.gov; i=@tycho.nsa.gov; q=dns/txt;
  s=tycho.nsa.gov; t=1558116343; x=1589652343;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=L81ajlJo+CZ+OjwVY7q/ORl8uEQ7X8zOI/SaAPxZkQo=;
  b=n6Pj6HCgAa9mlDcyFW/sxycDyFa/jtGw49jHg1V2mHh6Xst3vZ4YyEd4
   fGYGuEnwX9M//b020N91uT+Otyk3HZLzqh2oTqcyleIh2vLt1hKYJklNp
   0S+GpaM5Qf2cCxI+fq7TvA8EuYuWYr0cOU6PhuUeR0mQPS5WuZzS3u3S4
   odqmdXW/jo6Q2IMxoMnNhsVLT2PY5zKztXsMoBPS2O29DVKDXR6gdl68y
   rIJeKjWPHKBqrrLpDJUHs6kYkzirhNpdk3Ymtea9in/ld1l8KScf71qqt
   n8k4C9xiCK/CxsdOX4EXu5XjSgUOgJrvgTNZmZ+h+Uf0STUlE8xb8G5JN
   g==;
X-IronPort-AV: E=Sophos;i="5.60,480,1549929600"; 
   d="scan'208";a="27874825"
IronPort-PHdr: =?us-ascii?q?9a23=3Ax/zR3RUVJAomAyAHJUBfnZRh8JnV8LGtZVwlr6?=
 =?us-ascii?q?E/grcLSJyIuqrYZhGOtKdThVPEFb/W9+hDw7KP9fy5ACpZuczK6SpbOLV3FD?=
 =?us-ascii?q?Y9wf0MmAIhBMPXQWbaF9XNKxIAIcJZSVV+9Gu6O0UGUOz3ZlnVv2HgpWVKQk?=
 =?us-ascii?q?a3OgV6PPn6FZDPhMqrye+y54fTYwJVjzahfL9+Nhq7oRjMusUMnIduNrg9xh?=
 =?us-ascii?q?TUrndWZuhd2H9lK0+Ukxvg/Mm74YRt8z5Xu/Iv9s5AVbv1cqElRrFGDzooLn?=
 =?us-ascii?q?446tTzuRbMUQWA6H0cUn4LkhVTGAjK8Av6XpbqvSTksOd2xTSXMtf3TbAwXj?=
 =?us-ascii?q?Si8rtrRRr1gyoJKzI17GfagdFrgalFvByuuQBww4/MYIGUKvV+eL/dfcgHTm?=
 =?us-ascii?q?ZFR8pdSjBNDp+5Y4YJAeUBJ+JYpJTjqVUIoxW1GA2gCPrvxzJMg3P727Ax3e?=
 =?us-ascii?q?Y8HgHcxAEuAswAsHrUotv2OqkdX++6w6vUwjvMdP5WxTXw5ZLUfhw9r/yBX7?=
 =?us-ascii?q?R9etfRx0k1EAPFi02dp5H5PzyLzuQNs3aU7+x9Xuyyjm4osQVxojyxycYsl4?=
 =?us-ascii?q?LEgZkVxU3f9Shi3IY0JcG3SE58YdK+FptQrDuVO5F5QsMlXWFloSA3waAFt5?=
 =?us-ascii?q?6jZCUG1ZsqyhHFZ/GHboSE+AzvWemPLTtimX5ofq+0iQyo/ki60OL8U9G50F?=
 =?us-ascii?q?NNriVYjNbBrmsN1xnP6sifTft941uh1S6P1w/N7uFEJlg5lbbBJJ47w74wi4?=
 =?us-ascii?q?ETvV7fHi72hEr2jKiWel8i+ue08OTofq/qppqdN49wkg3+M6IuldKjAekgLw?=
 =?us-ascii?q?QDUGeW9f682bH+50H1XrpHguMsnqXEqJzaIN4Upq+9Aw9byIYj7BO/Ai+90N?=
 =?us-ascii?q?sFhnkKN05FeRKbgIjpPFHCOvb4DeyljFi2nzdrwO7GMqX7AprRNnjDjKvhfb?=
 =?us-ascii?q?Fl5k5Y1Qoz0ddf6olOBbEEOv38RlX+tMTZDh8lKQO0x/zrCNNj2YMCQWiPGL?=
 =?us-ascii?q?OWMLvOsV+U4eIiO/KMa5EPtzb7MfQl5eTigmM5mV8HfKmpxocXaHegHvRmPU?=
 =?us-ascii?q?qZe2HsgtAHEWoRvwo+SvDqh0OGUTJJe3myWKc87CkhCI26FYfDWpytgLuZ0S?=
 =?us-ascii?q?inAJJZe3pGClGQHnvyeISEWvEMaC2JL89glDwESaauS4s72R6ysw/6zqJtLv?=
 =?us-ascii?q?DI9S0AqZLjyN916vXXlREv6Tx0CN+Q02KTQGFumGMHWTs20Lp4oUxnxVeJyb?=
 =?us-ascii?q?J4jOBAFdxP+/NJVR83NZzZz+x9EdDyQAPBfsySRVagWNqmBC8+TtMrz98JeU?=
 =?us-ascii?q?Z9FM2ojgrf0CqyH78Vi7uLCYQv8q3CxXjxKNhyxm3G1KY7i1kmRstONWu8iq?=
 =?us-ascii?q?Fj8AjTApbDk1+FmKayaaQcwCnN+X+HzWqPukFYTQFxXbzeXX8BekTWsM755k?=
 =?us-ascii?q?LeT76uELgnNwxBxtOfKqtOdNLklktGRPj9N9TEeW6xmHm/BQyOxrySaIrmYW?=
 =?us-ascii?q?Id3D/SCEIciQAc4W6GNRQiBiemu2/eFCZhFU/rY0736elxsm67TkstwwGPaE?=
 =?us-ascii?q?1h0KC19QAPifOATPMT26oOuD09pDVsAFa9w9XWBsKeqAp5Zqpce9I94Exc2G?=
 =?us-ascii?q?LBrQN9JJ2gL7t6hl4aaQt4o13h2w9wCoVansggtGkqwxZqKaKEzFNBcCuV3Y?=
 =?us-ascii?q?vuNb3TK2ny+g2vaqHN11HA39aZ5L0P5O47q1r9pgGpEFQt83F939lSyXuc6Y?=
 =?us-ascii?q?3ADBAOXpLpTkY36x96qqnYYiYn/YPU1n5sMa6uvj/Zwd0pB+glyhemf9hBNq?=
 =?us-ascii?q?OJDwvyE8wcB8izJ+0mgVmpbhQYPO9M8K44Jd+pd/yD2KSzJuZvgCqmjXhb4I?=
 =?us-ascii?q?B6yk+M9TRzSvLI35YfxPGVxQWHVzDmjFe9qM/3n4FEZD4IEmWjzijkAZZbZr?=
 =?us-ascii?q?ducoYTFWeuP8q3y81jiJH3RX5X6kSvB1Mc18+vYhqdcVr90BZR1UQRvXyohy?=
 =?us-ascii?q?+4wyZonDEuq6qVxDbOzPj6dBobJm5LQ3FvjUvjIYiwgNEXR0yobwkvlBu4+U?=
 =?us-ascii?q?b63a9bpKJ+L2jcW0tHYjb5JXl4UqSsrrqCf9JP6JQwvCVYSuSzf1+aR6XjrB?=
 =?us-ascii?q?sc0SPsAW9exDQ6dz62oJn2gxt6iGeFJnZpsHXZYd1wxQvY5NHEWf5R2SAGRD?=
 =?us-ascii?q?dihjnTG1e8JMKk/dGVl5fFr+C/WHutVpNUcSn2y4OPqTG05XFrAR24mfC/gN?=
 =?us-ascii?q?rnERI10SXjzdllST3IrArgYonsz6m6NeNnfk91BF7z8sZ6GZ9xkpE2hJ4O3X?=
 =?us-ascii?q?gXnYuV/XUZnmfpK9lb2rzxbGALRTEVx97Z+g/l2FdsLniR3YL2Sm2dwtd9Z9?=
 =?us-ascii?q?m9em4X1SEw4sFRBaeX8rNEhy11rUS8rQ7LZvh9hDgdw+M06HEGm+EJpBYtzi?=
 =?us-ascii?q?KFD7AWHElYOzHslhuR49Clo6VWa32icaa/1EVgh9CtFrKCrR9GWHb/ZJgiGT?=
 =?us-ascii?q?V87sJlMFLDyHfz8J3reMHMbdIPsR2Ziw3Pj+tNKJI0jfcKgStnOWTgvXwq0u?=
 =?us-ascii?q?I7gxtu3Yy8vIeaMWpt4KO5AhleNjHvYMMT4D7th75EnsmKx4CvAolhGjITUZ?=
 =?us-ascii?q?vuTfKoFygStfH9OAaICzA8sGmUFqffHQCF9EdqtW7AE5euN3uPPnkW0c1iRA?=
 =?us-ascii?q?WBJExYmA0UWi06npslGQ+23sPhdEN55i0U5lPjsBtD1P9nNxnlXWfDvgundj?=
 =?us-ascii?q?A0SJ2HJhpM8g5C/1vVMdCZ7u9rBCFX4IehrAOTJWCBfQtJDWYJWlGCB134P7?=
 =?us-ascii?q?mu48XA/PacBuakM/TOZrCOo/REV/iU3ZKvzpdm/zGUO8WUPnltFf061lBAXX?=
 =?us-ascii?q?9jB8TYmiwDSi0NmCLIbs6bvgyx+ixxrsCj7vvrXBjj6peIC7tXKd9v4Qy5gb?=
 =?us-ascii?q?+fN+6MgyZ0MTZY2YkNxX/U0rcf20QeiyFzdza3F7QAujXATKPWmq9LEREbbz?=
 =?us-ascii?q?l/O9dP76I5xgNNI9LUisvp1r5kif44E01KVVr8lcGzZMwLI3uxNEjHBEmVKr?=
 =?us-ascii?q?SJOT3LzN/xYaO/Tr1dl+FUtxy2uTaGHE7vJDWDlz/1Vx+xNeFAlj2UPBtbuI?=
 =?us-ascii?q?ulaBZiFXDjTM76ah28KNJ3jic5wbwuinPRK24TKzh8c0VWo72R6yNYnutwG2?=
 =?us-ascii?q?hb4nV5KumEnj6T7/PEJZYOrftrHiN0mvpB73Qi0LZa9iVERP1rlyvUrdNiuU?=
 =?us-ascii?q?ypnfeXwDp9TBVOsipLhJ6MvUh6O6XZ8YJAWXbf8RIP6mWQEBQKp8d/Ct3uo6?=
 =?us-ascii?q?BQzsbAlL7vKDtY9NLU58QcDdDOKM2bKHohLQbpGDnMAQsGVzGrNHvTh0xAkP?=
 =?us-ascii?q?6I8H2VoYM3qpnqmJoSVLBbUEY5Ge8dCkRgBNYCOot4Xis4kb6Hi84F/WC+rB?=
 =?us-ascii?q?jPS8VcopDHVOydAe70JTaWirlEYBQIwbfmIogJKoL73EliORFGm9HjHUbBFf?=
 =?us-ascii?q?RQvipkbxUvo0QFpHxjUmob0kfsYQq14WMaEbiykwJg2SVkZuF4zyvh+1c6IB?=
 =?us-ascii?q?LxoSI0lEQg0YH+jSu5bC/6LKD2W5pfTSXzqR5iYdvAXw9pYFjqzgRfPzDeSu?=
 =?us-ascii?q?cU1uYxeA=3D=3D?=
X-IPAS-Result: =?us-ascii?q?A2ADAQA5995c/wHyM5BkGwEBAQEDAQEBBwMBAQGBZYFiB?=
 =?us-ascii?q?SqBNgUyKIQSkwtQAQEGgQgIJYlOkQIJAQEBAQEBAQEBNAECAQGEQAKCNCM4E?=
 =?us-ascii?q?wEDAQEBBAEBAQEDAQFsKII6KQGCZwEFIxVBEAsOCgICJgICVwYNBgIBAYJfP?=
 =?us-ascii?q?4F3FKsCgS+FSIMogUaBDCiLURd4gQeBEScMgl8+h06CWASNRIV8lFYJgg2CD?=
 =?us-ascii?q?5BmBhuWGKQWIYFXKwgCGAghD4MnkG0jAzCBBgEBj10BAQ?=
Received: from tarius.tycho.ncsc.mil ([144.51.242.1])
  by emsm-gh1-uea11.NCSC.MIL with ESMTP; 17 May 2019 18:05:40 +0000
Received: from moss-pluto.infosec.tycho.ncsc.mil (moss-pluto [192.168.25.131])
        by tarius.tycho.ncsc.mil (8.14.4/8.14.4) with ESMTP id x4HI5d4T009933;
        Fri, 17 May 2019 14:05:39 -0400
Subject: Re: SGX vs LSM (Re: [PATCH v20 00/28] Intel SGX1 support)
To:     Andy Lutomirski <luto@amacapital.net>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        "Xing, Cedric" <cedric.xing@intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        James Morris <jmorris@namei.org>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        LSM List <linux-security-module@vger.kernel.org>,
        Paul Moore <paul@paul-moore.com>,
        Eric Paris <eparis@parisplace.org>,
        "selinux@vger.kernel.org" <selinux@vger.kernel.org>,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        Jethro Beekman <jethro@fortanix.com>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Dr. Greg" <greg@enjellic.com>,
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
        David Rientjes <rientjes@google.com>
References: <20190515013031.GF1977@linux.intel.com>
 <CALCETrXf8mSK45h7sTK5Wf+pXLVn=Bjsc_RLpgO-h-qdzBRo5Q@mail.gmail.com>
 <alpine.LRH.2.21.1905160543070.19802@namei.org>
 <CALCETrX_Q6qwNRNF0TL2tgfm1j6DKLX7NVHHmWbMFtk3WnHDKw@mail.gmail.com>
 <alpine.LRH.2.21.1905160844130.29250@namei.org>
 <CALCETrX2ovRx3Rre+1_xC-q6CiybyLjQ-gmB4FZF_qCZ-Qd+4A@mail.gmail.com>
 <960B34DE67B9E140824F1DCDEC400C0F654E38CD@ORSMSX116.amr.corp.intel.com>
 <CALCETrUfmyQ7ivNzQic0FyPXe1fmAnoK093jnz0i8DRn2LvdSA@mail.gmail.com>
 <960B34DE67B9E140824F1DCDEC400C0F654E3FB9@ORSMSX116.amr.corp.intel.com>
 <6a97c099-2f42-672e-a258-95bc09152363@tycho.nsa.gov>
 <20190517150948.GA15632@linux.intel.com>
 <ca807220-47e2-5ec2-982c-4fb4a72439c6@tycho.nsa.gov>
 <80013cca-f1c2-f4d5-7558-8f4e752ada76@tycho.nsa.gov>
 <837CE33B-A636-4BF8-B46E-0A8A40C5A563@amacapital.net>
From:   Stephen Smalley <sds@tycho.nsa.gov>
Message-ID: <6d083885-1880-f33d-a54f-23518d56b714@tycho.nsa.gov>
Date:   Fri, 17 May 2019 14:05:39 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <837CE33B-A636-4BF8-B46E-0A8A40C5A563@amacapital.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On 5/17/19 1:12 PM, Andy Lutomirski wrote:
> 
> 
>> On May 17, 2019, at 9:37 AM, Stephen Smalley <sds@tycho.nsa.gov> wrote:
>>
>>> On 5/17/19 12:20 PM, Stephen Smalley wrote:
>>>> On 5/17/19 11:09 AM, Sean Christopherson wrote:
>>>>> On Fri, May 17, 2019 at 09:53:06AM -0400, Stephen Smalley wrote:
>>>>>> On 5/16/19 6:23 PM, Xing, Cedric wrote:
>>>>>> I thought EXECMOD applied to files (and memory mappings backed by them) but
>>>>>> I was probably wrong. It sounds like EXECMOD applies to the whole process so
>>>>>> would allow all pages within a process's address space to be modified then
>>>>>> executed, regardless the backing files. Am I correct this time?
>>>>>
>>>>> No, you were correct the first time I think; EXECMOD is used to control
>>>>> whether a process can make executable a private file mapping that has
>>>>> previously been modified (e.g. text relocation); it is a special case to
>>>>> support text relocations without having to allow full EXECMEM (i.e. execute
>>>>> arbitrary memory).
>>>>>
>>>>> SELinux checks relevant to W^X include:
>>>>>
>>>>> - EXECMEM: mmap/mprotect PROT_EXEC an anonymous mapping (regardless of
>>>>> PROT_WRITE, since we know the content has to have been written at some
>>>>> point) or a private file mapping that is also PROT_WRITE.
>>>>> - EXECMOD: mprotect PROT_EXEC a private file mapping that has been
>>>>> previously modified, typically for text relocations,
>>>>> - FILE__WRITE: mmap/mprotect PROT_WRITE a shared file mapping,
>>>>> - FILE__EXECUTE: mmap/mprotect PROT_EXEC a file mapping.
>>>>>
>>>>> (ignoring EXECSTACK and EXECHEAP here since they aren't really relevant to
>>>>> this discussion)
>>>>>
>>>>> So if you want to ensure W^X, then you wouldn't allow EXECMEM for the
>>>>> process, EXECMOD by the process to any file, and the combination of both
>>>>> FILE__WRITE and FILE__EXECUTE by the process to any file.
>>>>>
>>>>> If the /dev/sgx/enclave mappings are MAP_SHARED and you aren't using an
>>>>> anonymous inode, then I would expect that only the FILE__WRITE and
>>>>> FILE__EXECUTE checks are relevant.
>>>>
>>>> Yep, I was just typing this up in a different thread:
>>>>
>>>> I think we may want to change the SGX API to alloc an anon inode for each
>>>> enclave instead of hanging every enclave off of the /dev/sgx/enclave inode.
>>>> Because /dev/sgx/enclave is NOT private, SELinux's file_map_prot_check()
>>>> will only require FILE__WRITE and FILE__EXECUTE to mprotect() enclave VMAs
>>>> to RWX.  Backing each enclave with an anon inode will make SELinux treat
>>>> EPC memory like anonymous mappings, which is what we want (I think), e.g.
>>>> making *any* EPC page executable will require PROCESS__EXECMEM (SGX is
>>>> 64-bit only at this point, so SELinux will always have default_noexec).
>>> I don't think we want to require EXECMEM (or equivalently both FILE__WRITE and FILE__EXECUTE to /dev/sgx/enclave) for making any EPC page executable, only if the page is also writable or previously modified.  The intent is to prevent arbitrary code execution without EXECMEM (or FILE__WRITE|FILE__EXECUTE), while still allowing enclaves to be created without EXECMEM as long as the EPC page mapping is only ever mapped RX and its initial contents came from an unmodified file mapping that was PROT_EXEC (and hence already checked via FILE__EXECUTE).
>>
>> Also, just to be clear, there is nothing inherently better about checking EXECMEM instead of checking both FILE__WRITE and FILE__EXECUTE to the /dev/sgx/enclave inode, so I wouldn't switch to using anon inodes for that reason.  Using anon inodes also unfortunately disables SELinux inode-based checking since we no longer have any useful inode information, so you'd lose out on SELinux ioctl whitelisting on those enclave inodes if that matters.
> 
> How can that work?  Unless the API changes fairly radically, users fundamentally need to both write and execute the enclave.  Some of it will be written only from already executable pages, and some privilege should be needed to execute any enclave page that was not loaded like this.

I'm not sure what the API is. Let's say they do something like this:

fd = open("/dev/sgx/enclave", O_RDONLY);
addr = mmap(NULL, size, PROT_READ | PROT_EXEC, MAP_SHARED, fd, 0);
stuff addr into ioctl args
ioctl(fd, ENCLAVE_CREATE, &ioctlargs);
ioctl(fd, ENCLAVE_ADD_PAGE, &ioctlargs);
ioctl(fd, ENCLAVE_INIT, &ioctlargs);

The important points are that they do not open /dev/sgx/enclave with 
write access (otherwise they will trigger FILE__WRITE at open time, and 
later encounter FILE__EXECUTE as well during mmap, thereby requiring 
both to be allowed to /dev/sgx/enclave), and that they do not request 
PROT_WRITE to the resulting mapping (otherwise they will trigger 
FILE__WRITE at mmap time).  Then only FILE__READ and FILE__EXECUTE are 
required to /dev/sgx/enclave in policy.

If they switch to an anon inode, then any mmap PROT_EXEC of the opened 
file will trigger an EXECMEM check, at least as currently implemented, 
as we have no useful backing inode information.
