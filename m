Return-Path: <SRS0=97/O=TP=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98FDCC04E53
	for <linux-sgx@archiver.kernel.org>; Wed, 15 May 2019 18:27:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5C37C21473
	for <linux-sgx@archiver.kernel.org>; Wed, 15 May 2019 18:27:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1557944839;
	bh=eyCci4NNHW/Zb8xOIWX1uiuQImd0sVgqVJNMBUtSyzo=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=pscJbLmFehSc9ZJuSn9owyHwVbQ1FnyYLmuYvLcZD6l2tRa1BO8xJA7TCYjKAxBY5
	 WCQp3DSOoM+DdhTrIscnIKIIQe/gWM6ucCh4POHXNhAYJU7j3aMSlD9gj1OcGYQVay
	 Ya6GloEn5bauImGlyOR/2IcaI39F9jzn63mOJko8=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727221AbfEOS1T (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 15 May 2019 14:27:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:34172 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726775AbfEOS1S (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 15 May 2019 14:27:18 -0400
Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2A6AC2166E
        for <linux-sgx@vger.kernel.org>; Wed, 15 May 2019 18:27:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557944837;
        bh=eyCci4NNHW/Zb8xOIWX1uiuQImd0sVgqVJNMBUtSyzo=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=l+ze3bM9Xdq86BlYng6FD78FmBq7OVBDoDLIvX6TPDXdbjyb53Eyyr3Gmo9FBNwB0
         VrEqBdvsYZznlPOWMqDeTQUbWDUQTB005XXgyHcaKsKlEvQjgebrHzPDQQRDk3LPvN
         ZIXgbS7QZBNVKlbDrXxccBz6lOFRTKcRFQInOmbw=
Received: by mail-wr1-f47.google.com with SMTP id w8so567782wrl.6
        for <linux-sgx@vger.kernel.org>; Wed, 15 May 2019 11:27:17 -0700 (PDT)
X-Gm-Message-State: APjAAAUSi4EWjJ8GJ1T1Ipu0NFpfHY5NEK5tBYVd/1aeTTv2jwG8is2R
        vyVFdO6LRCbZjsEa/aFhUAnfiyrPwsOBY82GX6AwmQ==
X-Google-Smtp-Source: APXvYqy1pLyH4lK8J6UTt9LHYCA38HWu3si0XcCqLyKwswu7vOKZJZQHgx27uHEnWm6r8QGqq5mTnXm8Ea9kev7zK7A=
X-Received: by 2002:a5d:4907:: with SMTP id x7mr14732988wrq.199.1557944835683;
 Wed, 15 May 2019 11:27:15 -0700 (PDT)
MIME-Version: 1.0
References: <8fe520bb-30bd-f246-a3d8-c5443e47a014@intel.com>
 <358e9b36-230f-eb18-efdb-b472be8438b4@fortanix.com> <960B34DE67B9E140824F1DCDEC400C0F4E886094@ORSMSX116.amr.corp.intel.com>
 <6da269d8-7ebb-4177-b6a7-50cc5b435cf4@fortanix.com> <CALCETrWCZQwg-TUCm58DVG43=xCKRsMe1tVHrR8vdt06hf4fWA@mail.gmail.com>
 <20190513102926.GD8743@linux.intel.com> <20190514104323.GA7591@linux.intel.com>
 <CALCETrVbgTCnPo=PAq0-KoaRwt--urrPzn==quAJ8wodCpkBkw@mail.gmail.com>
 <20190514204527.GC1977@linux.intel.com> <CALCETrX6aL367mMJh5+Y1Seznfu-AvhPV6P7GkWF4Dhu0GV8cw@mail.gmail.com>
 <20190515013031.GF1977@linux.intel.com>
In-Reply-To: <20190515013031.GF1977@linux.intel.com>
From:   Andy Lutomirski <luto@kernel.org>
Date:   Wed, 15 May 2019 11:27:04 -0700
X-Gmail-Original-Message-ID: <CALCETrXf8mSK45h7sTK5Wf+pXLVn=Bjsc_RLpgO-h-qdzBRo5Q@mail.gmail.com>
Message-ID: <CALCETrXf8mSK45h7sTK5Wf+pXLVn=Bjsc_RLpgO-h-qdzBRo5Q@mail.gmail.com>
Subject: SGX vs LSM (Re: [PATCH v20 00/28] Intel SGX1 support)
To:     Sean Christopherson <sean.j.christopherson@intel.com>,
        James Morris <jmorris@namei.org>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        LSM List <linux-security-module@vger.kernel.org>,
        Paul Moore <paul@paul-moore.com>,
        Stephen Smalley <sds@tycho.nsa.gov>,
        Eric Paris <eparis@parisplace.org>, selinux@vger.kernel.org
Cc:     Andy Lutomirski <luto@kernel.org>,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        Jethro Beekman <jethro@fortanix.com>,
        "Xing, Cedric" <cedric.xing@intel.com>,
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

Hi, LSM and SELinux people-

We're trying to figure out how SGX fits in with LSMs.  For background,
an SGX library is functionally a bit like a DSO, except that it's
nominally resistant to attack from outside and the process of loading
it is complicated.  To load an enclave, a program can open
/dev/sgx/enclave, do some ioctls to load the code and data segments
into the enclave, call a special ioctl to "initialize" the enclave,
and then call into the enclave (using special CPU instructions).

One nastiness is that there is not actually a universally agreed upon,
documented file format for enclaves.  Windows has an undocumented
format, and there are probably a few others out there.  No one really
wants to teach the kernel to parse enclave files.

There are two issues with how this interacts with LSMs:

1) LSMs might want to be able to whitelist, blacklist, or otherwise
restrict what enclaves can run at all.  The current proposal that
everyone seems to dislike the least is to have a .sigstruct file on
disk that contains a hash and signature of the enclave in a
CPU-defined format.  To initialize an enclave, a program will pass an
fd to this file, and a new LSM hook can be called to allow or disallow
the operation.  In a SELinux context, the idea is that policy could
require the .sigstruct file to be labeled with a type like
sgx_sigstruct_t, and only enclaves that have a matching .sigstruct
with such a label could run.

2) Just like any other DSO, there are potential issues with how
enclaves deal with writable vs executable memory.  This takes two
forms.  First, a task should probably require EXECMEM, EXECMOD, or
similar permission to run an enclave that can modify its own text.
Second, it would be nice if a task that did *not* have EXECMEM,
EXECMOD, or similar could still run the enclave if it had EXECUTE
permission on the file containing the enclave.

Currently, this all works because DSOs are run by mmapping the file to
create multiple VMAs, some of which are executable, non-writable, and
non-CoWed, and some of which are writable but not executable.  With
SGX, there's only really one inode per enclave (the anon_inode that
comes form /dev/sgx/enclave), and it can only be sensibly mapped
MAP_SHARED.

With the current version of the SGX driver, to run an enclave, I think
you'll need either EXECUTE rights to /dev/sgx/enclave or EXECMOD or
similar, all of which more or less mean that you can run any modified
code you want, and none of which is useful to prevent enclaves from
contain RWX segments.

So my question is: what, if anything, should change to make this work bette=
r?

Here's a very vague proposal that's kind of like what I've been
thinking over the past few days.  The SGX inode could track, for each
page, a "safe-to-execute" bit.  When you first open /dev/sgx/enclave,
you get a blank enclave and all pages are safe-to-execute.  When you
do the ioctl to load context (which could be code, data, or anything
else), the kernel will check whether the *source* VMA is executable
and, if not, mark the page of the enclave being loaded as unsafe.
Once the enclave is initialized, the driver will clear the
safe-to-execute bit for any page that is successfully mapped writably.

The intent is that a page of the enclave is safe-to-execute if that
page was populated from executable memory and not modified since then.
LSMs could then enforce a policy that you can map an enclave page RX
if the page is safe-to-execute, you can map any page you want for
write if there are no executable mappings, and you can only map a page
for write and execute simultaneously if you can EXECMOD permission.
This should allow an enclave to be loaded by userspace from a file
with EXECUTE rights.

So here are my questions:

Are the goals I mentioned reasonable?

Is the design I just outlined reasonable?  Would SELinux support this?

Is there a better solution that works well enough?

Thanks, all!

> On May 14, 2019, at 6:30 PM, Sean Christopherson <sean.j.christopherson@i=
ntel.com> wrote:
>
>
>> But thinking this all through, it's a bit more complicated than any of
>> this.  Looking at the SELinux code for inspiration, there are quite a
>> few paths, but they boil down to two cases: EXECUTE is the right to
>> map an unmodified file executably, and EXECMOD/EXECMEM (the
>> distinction seems mostly irrelevant) is the right to create (via mmap
>> or mprotect) a modified anonymous file mapping or a non-file-backed
>> mapping that is executable.  So, if we do nothing, then mapping an
>> enclave with execute permission will require either EXECUTE on the
>> enclave inode or EXECMOD/EXECMEM, depending on exactly how this gets
>> set up.
>
> If we do literally nothing, then I'm pretty sure mapping an enclave will
> require PROCESS__EXECMEM.  The mmap() for the actual enclave is done
> using an anon inode, e.g. from /dev/sgx/enclave.  Anon inodes are marked
> private, which means inode_has_perm() will always return "success".  The
> only effective check is in file_map_prot_check() when default_noexec is
> true, in which case requesting PROT_EXEC on private inodes requires
> PROCESS__EXECMEM.
>
>> So all is well, sort of.  The problem is that I expect there will be
>> people who want enclaves to work in a process that does not have these
>> rights.  To make this work, we probably need do some surgery on
>> SELinux.  ISTM the act of copying (via the EADD ioctl) data from a
>> PROT_EXEC mapping to an enclave should not be construed as "modifying"
>> the enclave for SELinux purposes.  Actually doing this could be
>> awkward, since the same inode will have executable parts and
>> non-executable parts, and SELinux can't really tell the difference.
>
> Rather the do surgery on SELinux, why not go with Cedric's original
> proposal and propagate the permissions from the source VMA to the EPC
> VMA?

Which EPC VMA?  Users can map the enclave fd again after EADD,
resulting in a new VMA.  And any realistic enclave will presumably
have RO, RW, and RX pages.

>  The enclave mmap() from userspace could then be done with RO
> permissions so as to not run afoul of LSMs.  Adding PROT_EXEC after
> EADD would require PROCESS__EXECMEM, but that's in line with mprotect()
> on regular memory.

How does this help anything?  The driver currently only works with
EXECMEM and, with this change, it still needs EXECMEM.

I think that, if we=E2=80=99re going to make changes along these lines, the
goal should be that you can have an enclave serialized in a file on
disk such that you have EXECUTE on the file, and you should be able to
load and run the enclave without needing EXECMEM.  (Unless the enclave
is self-modifying, of course.)
