Return-Path: <SRS0=m9nj=TQ=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C23E2C04AB4
	for <linux-sgx@archiver.kernel.org>; Thu, 16 May 2019 04:40:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 88C052168B
	for <linux-sgx@archiver.kernel.org>; Thu, 16 May 2019 04:40:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1557981639;
	bh=38ylCjlm5iAP/Ou8rSegy/JItYb7X26CL4djObD2NAs=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=NhiL4+Qllh7Ilm/ibMSMtABMBQIojBI6z/H5aAThxYTehnTKHKJI9Bvtu5hfCTtok
	 GMlk4RptZmjEbI2EpEEOrj2XYiPT+XSzqdPeb4PlWdqYHqokwF5ASKK54ahtpU9EdP
	 nS3RISj/3ytfvfpoxpZab9WYcngelEjCYeruqPPU=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726513AbfEPEkj (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 16 May 2019 00:40:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:48232 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726336AbfEPEki (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 16 May 2019 00:40:38 -0400
Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 406B421773
        for <linux-sgx@vger.kernel.org>; Thu, 16 May 2019 04:40:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557981637;
        bh=38ylCjlm5iAP/Ou8rSegy/JItYb7X26CL4djObD2NAs=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=Oc4gkqwIBEAfsGndmhrY2fSi23HeojozZkvemcvde6sChHVslDNFY4pYPkZh/BYLH
         XJ+o9tpsEiU4rBqW5zU81Xl1XAIAR3DzjocV7BtNijI2RaaEt/HC98GfICXGSfRCrd
         4KJCj7QBPzmgS19OzZNQVHk9PNL2hPc1zr6yW7l4=
Received: by mail-wm1-f49.google.com with SMTP id j187so1969651wmj.1
        for <linux-sgx@vger.kernel.org>; Wed, 15 May 2019 21:40:37 -0700 (PDT)
X-Gm-Message-State: APjAAAWQ9TRLWg/VrEgVntEgeXWJtgkzPt6WgZFyLEE111Nubc6UiP3N
        f2rx8hegGl9gG/Y0GD8ZNbv0DI9vFG+p6VsQFeu7ew==
X-Google-Smtp-Source: APXvYqzROYtIxqkjhdn79+zJ7p3zNsiMWwvYuddRT0OAHYdmnxPjv/FuKmbs6R9PAXuS/de56lFOw6TKw5WA5KIsla4=
X-Received: by 2002:a1c:486:: with SMTP id 128mr24234379wme.83.1557981635591;
 Wed, 15 May 2019 21:40:35 -0700 (PDT)
MIME-Version: 1.0
References: <8fe520bb-30bd-f246-a3d8-c5443e47a014@intel.com>
 <358e9b36-230f-eb18-efdb-b472be8438b4@fortanix.com> <960B34DE67B9E140824F1DCDEC400C0F4E886094@ORSMSX116.amr.corp.intel.com>
 <6da269d8-7ebb-4177-b6a7-50cc5b435cf4@fortanix.com> <CALCETrWCZQwg-TUCm58DVG43=xCKRsMe1tVHrR8vdt06hf4fWA@mail.gmail.com>
 <20190513102926.GD8743@linux.intel.com> <20190514104323.GA7591@linux.intel.com>
 <CALCETrVbgTCnPo=PAq0-KoaRwt--urrPzn==quAJ8wodCpkBkw@mail.gmail.com>
 <20190514204527.GC1977@linux.intel.com> <CALCETrX6aL367mMJh5+Y1Seznfu-AvhPV6P7GkWF4Dhu0GV8cw@mail.gmail.com>
 <20190515013031.GF1977@linux.intel.com> <CALCETrXf8mSK45h7sTK5Wf+pXLVn=Bjsc_RLpgO-h-qdzBRo5Q@mail.gmail.com>
 <alpine.LRH.2.21.1905160543070.19802@namei.org> <CALCETrX_Q6qwNRNF0TL2tgfm1j6DKLX7NVHHmWbMFtk3WnHDKw@mail.gmail.com>
 <alpine.LRH.2.21.1905160844130.29250@namei.org> <CALCETrX2ovRx3Rre+1_xC-q6CiybyLjQ-gmB4FZF_qCZ-Qd+4A@mail.gmail.com>
 <960B34DE67B9E140824F1DCDEC400C0F654E38CD@ORSMSX116.amr.corp.intel.com>
In-Reply-To: <960B34DE67B9E140824F1DCDEC400C0F654E38CD@ORSMSX116.amr.corp.intel.com>
From:   Andy Lutomirski <luto@kernel.org>
Date:   Wed, 15 May 2019 21:40:23 -0700
X-Gmail-Original-Message-ID: <CALCETrUfmyQ7ivNzQic0FyPXe1fmAnoK093jnz0i8DRn2LvdSA@mail.gmail.com>
Message-ID: <CALCETrUfmyQ7ivNzQic0FyPXe1fmAnoK093jnz0i8DRn2LvdSA@mail.gmail.com>
Subject: Re: SGX vs LSM (Re: [PATCH v20 00/28] Intel SGX1 support)
To:     "Xing, Cedric" <cedric.xing@intel.com>
Cc:     Andy Lutomirski <luto@kernel.org>,
        James Morris <jmorris@namei.org>,
        "Christopherson, Sean J" <sean.j.christopherson@intel.com>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        LSM List <linux-security-module@vger.kernel.org>,
        Paul Moore <paul@paul-moore.com>,
        Stephen Smalley <sds@tycho.nsa.gov>,
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
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

> On May 15, 2019, at 8:03 PM, Xing, Cedric <cedric.xing@intel.com> wrote:
>
> Hi Andy,
>
>> From: Andy Lutomirski [mailto:luto@kernel.org]
>>
>>> On Wed, May 15, 2019 at 3:46 PM James Morris <jmorris@namei.org> wrote:
>>>
>>> On Wed, 15 May 2019, Andy Lutomirski wrote:
>>>
>>>>> Why not just use an xattr, like security.sgx ?
>>>>
>>>> Wouldn't this make it so that only someone with CAP_MAC_ADMIN could
>>>> install an enclave?  I think that this decision should be left up the
>>>> administrator, and it should be easy to set up a loose policy where
>>>> anyone can load whatever enclave they want.  That's what would happen
>>>> in my proposal if there was no LSM loaded or of the LSM policy didn't
>>>> restrict what .sigstruct files were acceptable.
>>>>
>>>
>>> You could try user.sigstruct, which does not require any privs.
>>>
>>
>> I don't think I understand your proposal.  What file would this
>> attribute be on?  What would consume it?
>>
>> I'm imagining that there's some enclave in a file
>> crypto_thingy.enclave.  There's also a file crypto_thingy.sigstruct.
>> crypto_thingy.enclave has type lib_t or similar so that it's
>> executable.  crypto_thingy.sigstruct has type sgx_sigstruct_t.  The
>> enclave loader does, in effect:
>>
>> void *source_data =3D mmap(crypto_thingy.enclave, PROT_READ | PROT_EXEC,=
 ...);
>> int sigstruct_fd =3D open("crypto_thingy.sigstruct", O_RDONLY);
>> int enclave_fd =3D open("/dev/sgx/enclave", O_RDWR);
>>
>> ioctl(enclave_fd, SGX_IOC_ADD_SOME_DATA, source_data + source_offset,
>> enclave_offset, len, ...);
>> ioctl(enclave_fd, SGX_IOC_ADD_SOME_DATA, source_data + source_offset2,
>> enclave_offset2, len, ...);
>> etc.
>>
>> /* Here's where LSMs get to check that the sigstruct is acceptable.
>> The CPU will check that the sigstruct matches the enclave. */
>> ioctl(enclave_fd, SGX_INIT_THE_ENCLAVE, sigstruct_fd);
>
> SIGSTRUCT isn't necessarily stored on disk so may not always have a fd. H=
ow about the following?
> void *ss_pointer =3D mmap(sigstruct_fd, PROT_READ,...);
> ioctl(enclave_fd, SGX_INIT_THE_ENCLAVE, ss_pointer);
>
> The idea here is SIGSTRUCT will still be passed in memory so it works the=
 same way when no LSM modules are loaded or basing its decision on the .sig=
struct file. Otherwise, an LSM module can figure out the backing file (and =
offset within that file) by looking into the VMA covering ss_pointer.

I don=E2=80=99t love this approach.  Application authors seem likely to use
read() instead of mmap(), and it=E2=80=99ll still work in many cares. It wo=
uld
also complicate the kernel implementation, and looking at the inode
backing the vma that backs a pointer is at least rather unusual.
Instead, if the sigstruct isn=E2=80=99t on disk because it=E2=80=99s dynami=
c or came
from a network, the application can put it in a memfd.

>
>>
>> /* Actually map the thing */
>> mmap(enclave_fd RO section, PROT_READ, ...);
>> mmap(enclave_fd RW section, PROT_READ | PROT_WRITE, ...);
>> mmap(enclave_fd RX section, PROT_READ | PROT_EXEC, ...);
>>
>> /* This should fail unless EXECMOD is available, I think */
>> mmap(enclave_fd RWX section, PROT_READ | PROT_WRITE | PROT_EXEC);
>>
>> And the idea here is that, if the .enclave file isn't mapped
>> PROT_EXEC, then mmapping the RX section will also require EXECMEM or
>> EXECMOD.
>
> From security perspective, I think it reasonable to give EXECMEM and EXEC=
MOD to /dev/sgx/enclave because the actual permissions are guarded by EPCM =
permissions, which are "inherited" from the source pages, whose permissions=
 have passed LSM checks.

I disagree.  If you deny a program EXECMOD, it=E2=80=99s not because you
distrust the program. It=E2=80=99s because you want to enforce good securit=
y
practices.  (Or you=E2=80=99re Apple and want to disallow third-party JITs.=
)
A policy that accepts any sigstruct but requires that enclaves come
from disk and respect W^X seems entirely reasonable.

I think that blocking EXECMOD has likely served two very real security
purposes. It helps force application and library developers to write
and compile their code in a way that doesn=E2=80=99t rely on dangerous tric=
ks
like putting executable trampolines on the stack.  It also makes it
essentially impossible for an exploit to run actual downloaded machine
code =E2=80=94 if there is no way to run code that isn=E2=80=99t appropriat=
ely
labeled, then attackers are more limited in what they can do.

I don=E2=80=99t think that SGX should become an exception to either of thes=
e.
Code should not have an excuse to use WX memory just because it=E2=80=99s i=
n
an enclave. Similarly, an exploit should not be able to run an
attacker-supplied enclave as a way around a policy that would
otherwise prevent downloaded code from running.


=E2=80=94Andy
