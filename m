Return-Path: <SRS0=nHr/=TO=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8CCCC04AB4
	for <linux-sgx@archiver.kernel.org>; Tue, 14 May 2019 21:08:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A0A2920873
	for <linux-sgx@archiver.kernel.org>; Tue, 14 May 2019 21:08:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726148AbfENVI5 convert rfc822-to-8bit (ORCPT
        <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 14 May 2019 17:08:57 -0400
Received: from mga05.intel.com ([192.55.52.43]:16713 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726036AbfENVI5 (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Tue, 14 May 2019 17:08:57 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 14 May 2019 14:08:56 -0700
X-ExtLoop1: 1
Received: from hhuan26-mobl.amr.corp.intel.com ([10.255.33.85])
  by orsmga001.jf.intel.com with ESMTP; 14 May 2019 14:08:52 -0700
Content-Type: text/plain; charset=utf-8; format=flowed; delsp=yes
To:     "Andy Lutomirski" <luto@kernel.org>
Cc:     "Jethro Beekman" <jethro@fortanix.com>,
        "Xing, Cedric" <cedric.xing@intel.com>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        "Thomas Gleixner" <tglx@linutronix.de>,
        "Dr. Greg" <greg@enjellic.com>,
        "Jarkko Sakkinen" <jarkko.sakkinen@linux.intel.com>,
        "Linus Torvalds" <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, "X86 ML" <x86@kernel.org>,
        "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        "Andrew Morton" <akpm@linux-foundation.org>,
        "Christopherson, Sean J" <sean.j.christopherson@intel.com>,
        "nhorman@redhat.com" <nhorman@redhat.com>,
        "npmccallum@redhat.com" <npmccallum@redhat.com>,
        "Ayoun, Serge" <serge.ayoun@intel.com>,
        "Katz-zamir, Shay" <shay.katz-zamir@intel.com>,
        "Huang, Haitao" <haitao.huang@intel.com>,
        "Andy Shevchenko" <andriy.shevchenko@linux.intel.com>,
        "Svahn, Kai" <kai.svahn@intel.com>,
        "Borislav Petkov" <bp@alien8.de>,
        "Josh Triplett" <josh@joshtriplett.org>,
        "Huang, Kai" <kai.huang@intel.com>,
        "David Rientjes" <rientjes@google.com>
Subject: Re: [PATCH v20 00/28] Intel SGX1 support
Reply-To: haitao.huang@linux.intel.com
References: <20190417103938.7762-1-jarkko.sakkinen@linux.intel.com>
 <e1478f70-7e44-6e3e-2aaf-1b12a96328ed@fortanix.com>
 <2AE80EA3-799E-4808-BBE4-3872F425BCF8@amacapital.net>
 <49b28ca1-6e66-87d9-2202-84c58f13fb99@fortanix.com>
 <444537E3-4156-41FB-83CA-57C5B660523F@amacapital.net>
 <f9d93291-9b59-7b66-de9f-af92246f1c9c@fortanix.com>
 <alpine.DEB.2.21.1904192337160.3174@nanos.tec.linutronix.de>
 <5854e66a-950e-1b12-5393-d9cdd15367dc@fortanix.com>
 <CALCETrV7CcDnx1hVtmBnDNABG11GuMqyspJMMpV+zHpVeFu3ow@mail.gmail.com>
 <960B34DE67B9E140824F1DCDEC400C0F4E885F9D@ORSMSX116.amr.corp.intel.com>
 <979615a8-fd03-e3fd-fbdb-65c1e51afd93@fortanix.com>
 <8fe520bb-30bd-f246-a3d8-c5443e47a014@intel.com>
 <358e9b36-230f-eb18-efdb-b472be8438b4@fortanix.com>
 <960B34DE67B9E140824F1DCDEC400C0F4E886094@ORSMSX116.amr.corp.intel.com>
 <6da269d8-7ebb-4177-b6a7-50cc5b435cf4@fortanix.com>
 <CALCETrWCZQwg-TUCm58DVG43=xCKRsMe1tVHrR8vdt06hf4fWA@mail.gmail.com>
 <op.z1saqpzxwjvjmi@hhuan26-mobl.amr.corp.intel.com>
 <CALCETrXHbRL-pzZ7CG+RrMNGNEPKO9LY=6Bo4tuFzcZ_ZTMQvQ@mail.gmail.com>
 <op.z1sdc6m4wjvjmi@hhuan26-mobl.amr.corp.intel.com>
 <CALCETrVfUfcs8ntj6tAzGo5eiaDGnLvUmgkUXNLX0a6SyJT+pg@mail.gmail.com>
Date:   Tue, 14 May 2019 16:08:52 -0500
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
From:   "Haitao Huang" <haitao.huang@linux.intel.com>
Organization: Intel
Message-ID: <op.z1ss02gdwjvjmi@hhuan26-mobl.amr.corp.intel.com>
In-Reply-To: <CALCETrVfUfcs8ntj6tAzGo5eiaDGnLvUmgkUXNLX0a6SyJT+pg@mail.gmail.com>
User-Agent: Opera Mail/1.0 (Win32)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Tue, 14 May 2019 15:45:54 -0500, Andy Lutomirski <luto@kernel.org>  
wrote:

>> On May 14, 2019, at 8:30 AM, Haitao Huang  
>> <haitao.huang@linux.intel.com> wrote:
>>
>>> On Tue, 14 May 2019 10:17:29 -0500, Andy Lutomirski <luto@kernel.org>  
>>> wrote:
>>>
>>> On Tue, May 14, 2019 at 7:33 AM Haitao Huang
>>> <haitao.huang@linux.intel.com> wrote:
>>>>
>>>> On Fri, 10 May 2019 14:22:34 -0500, Andy Lutomirski <luto@kernel.org>
>>>> wrote:
>>>>
>>>> > On Fri, May 10, 2019 at 12:04 PM Jethro Beekman  
>>>> <jethro@fortanix.com>
>>>> > wrote:
>>>> >>
>>>> >> On 2019-05-10 11:56, Xing, Cedric wrote:
>>>> >> > Hi Jethro,
>>>> >> >
>>>> >> >> ELF files are explicitly designed such that you can map them  
>>>> (with
>>>> >> mmap)
>>>> >> >> in 4096-byte chunks. However, sometimes there's overlap and you  
>>>> will
>>>> >> >> sometimes see that a particular offset is mapped twice because  
>>>> the
>>>> >> first
>>>> >> >> half of the page in the file belongs to an RX range and the  
>>>> second
>>>> >> half
>>>> >> >> to an R-only range. Also, ELF files don't (normally) describe  
>>>> stack,
>>>> >> >> heap, etc. which you do need for enclaves.
>>>> >> >
>>>> >> > You have probably misread my email. By mmap(), I meant the  
>>>> enclave
>>>> >> file would be mapped via *multiple* mmap() calls, in the same way  
>>>> as
>>>> >> what dlopen() would do in loading regular shared object. The  
>>>> intention
>>>> >> here is to make the enclave file subject to the same checks as  
>>>> regular
>>>> >> shared objects.
>>>> >>
>>>> >> No, I didn't misread your email. My original point still stands:
>>>> >> requiring that an enclave's memory is created from one or more mmap
>>>> >> calls of a file puts significant restrictions on the enclave's  
>>>> on-disk
>>>> >> representation.
>>>> >>
>>>> >
>>>> > For a tiny bit of background, Linux (AFAIK*) makes no effort to  
>>>> ensure
>>>> > the complete integrity of DSOs.  What Linux *does* do (if so
>>>> > configured) is to make sure that only approved data is mapped
>>>> > executable.  So, if you want to have some bytes be executable, those
>>>> > bytes have to come from a file that passes the relevant LSM and IMA
>>>> > checks.
>>>>
>>>> Given this, I just want to step back a little to understand the exact
>>>> issue that SGX is causing here for LSM/IMA. Sorry if I missed points
>>>> discussed earlier.
>>>>
>>>> By the time of EADD, enclave file is opened and should have passed  
>>>> IMA and
>>>> SELinux policy enforcement gates if any. We really don't need extra  
>>>> mmaps
>>>> on the enclave files to be IMA and SELinux compliant.
>>>
>>> The problem, as i see it, is that they passed the *wrong* checks,
>>> because, as you noticed:
>>>
>>>> We are loading
>>>> enclave files as RO and copying those into EPC.
>>>
>>> Which is, semantically, a lot like loading a normal file as RO and
>>> then mprotecting() it to RX, which is disallowed under quite a few LSM
>>> policies.
>>>
>>>> An IMA policy can enforce
>>>> RO files (or any file). And SELinux policy can say which processes can
>>>> open the file for what permissions. No extra needed here.
>>>
>>> If SELinux says a process may open a file as RO, that does *not* mean
>>> that it can be opened as RX.
>>>
>>
>> But in this case, file itself is mapped as RO treated like data and it  
>> is not for execution. SGX enclave pages have EPCM enforced permissions.  
>> So from SELinux point of view I would think it can treat it as RO and  
>> that's fine.
>
> As an example, SELinux has an “execute” permission (via
> security_mmap_file — see file_map_prot_check()) that controls whether
> you can execute code from that file.  If you lack this permission on a
> file, you may still be able to map it PROT_READ, but you may not map
> it PROT_EXEC.  Similarly, if you want to malloc() some memory, write
> *code* to it, and execute it, you need a specific permission.
>
> So, unless we somehow think it’s okay for SGX to break the existing
> model, we need to respect these restrictions in the SGX driver. In
> other words, we either need to respect execmem, etc or require
> PROT_EXEC or the equivalent. I like the latter a lot more.

What puzzles me is that this restriction does not add real value to  
security.
When enclave files are mapped with PROT_READ, without SE execute  
permission. No breakage to LSM model in normal process address space as no  
one can execute code directly from the file in normal memory. When enclave  
is built and loaded into EPC by EADDs, if the SIGSTRUCT is trusted (either  
signer or MRENCLAVE), EINIT will guarantee security (both integrity and  
permissions). LSM may not like the fact the a piece of code got loaded  
into EPC page without specifically giving SE execute permission. However,  
LSM can be used to control what SIGSTRUCTs can be trusted as you suggested  
and indirectly enforce what code got executed inside EPC.

So to me, only SIGSTRUCT verification would add value.
