Return-Path: <SRS0=Nb5J=TY=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,T_DKIMWL_WL_HIGH,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1A9BFC072B5
	for <linux-sgx@archiver.kernel.org>; Fri, 24 May 2019 19:38:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DC70621850
	for <linux-sgx@archiver.kernel.org>; Fri, 24 May 2019 19:38:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1558726683;
	bh=zeXvSbypTKhRfRRi8ROgKjL9915ASKgLD4WTaDTJcsU=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=Z6wMe2Jvnbejps39erBUyUibrHH8tCyzIw9YDcJyViJODFyhMAG9pcI/U+VLfShwl
	 zKDsy6EHlZamxtjBYarOCHRGMG/hD1J8AejxcxBoLgvsDxLt6VBl/cIxylyipylCP4
	 Y8QfzUfItZaofbPSJU3q0Zb7NE04mTa4NeHJ5M7s=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732113AbfEXTh7 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 24 May 2019 15:37:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:51344 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732005AbfEXTh7 (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Fri, 24 May 2019 15:37:59 -0400
Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com [209.85.221.50])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DD7D22189F
        for <linux-sgx@vger.kernel.org>; Fri, 24 May 2019 19:37:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558726678;
        bh=zeXvSbypTKhRfRRi8ROgKjL9915ASKgLD4WTaDTJcsU=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=L9Xq9286wjZcFleforj8AYP5lih/NPKby+xmRc+h3k3H7d3lLLCrNPbYubi13DNCs
         IfhUJRelKVp+LrLEwsaLcfiXWZ0gB0WsoGmAM14MWO9oXPJlSWGHtGF9q6qVlHLBZa
         DWq+ASWxROyaqTxSo6WWLjquaUebsZ2hL1IJh/UI=
Received: by mail-wr1-f50.google.com with SMTP id d9so11095756wrx.0
        for <linux-sgx@vger.kernel.org>; Fri, 24 May 2019 12:37:57 -0700 (PDT)
X-Gm-Message-State: APjAAAVIYSHh3snL9yWdtV4lGtk9i2UJoNC2L5Hxz1hsWrZShHhD+50o
        Fcn6uWtTrBs6AqxyFH6q5nW2O5UngoAfTbwThgr8lA==
X-Google-Smtp-Source: APXvYqzoAJQIK0k4dVkPIqLIvRg7W86cwwB38KRxh8ChAcf4YMC8WiiTW8e1QwmAaQ8iCYt40VtRWGOnhe7u0zTLVjY=
X-Received: by 2002:a5d:5506:: with SMTP id b6mr63452555wrv.221.1558726676250;
 Fri, 24 May 2019 12:37:56 -0700 (PDT)
MIME-Version: 1.0
References: <CALCETrUS8xyF1JJmQs18BGTDhPRXf+s81BkMZCZwmY73r7M+zg@mail.gmail.com>
 <20190523023517.GA31950@linux.intel.com> <20190523102628.GC10955@linux.intel.com>
 <20190523141752.GA12078@linux.intel.com> <CALCETrUzx3LPAKCLFf75P-XshAkRcr+JLET3LA_kHDs9MA11FA@mail.gmail.com>
 <20190523234044.GC12078@linux.intel.com> <CALCETrV4DVEfW6EJ6DnQGGYDJAiA5M1QcuYJTiroumOM+D6Jjg@mail.gmail.com>
 <960B34DE67B9E140824F1DCDEC400C0F654E8956@ORSMSX116.amr.corp.intel.com>
 <dda0912b-cb15-3c07-d368-345159e995f7@tycho.nsa.gov> <20190524174243.GA365@linux.intel.com>
 <20190524175458.GB365@linux.intel.com> <960B34DE67B9E140824F1DCDEC400C0F654E8E1D@ORSMSX116.amr.corp.intel.com>
In-Reply-To: <960B34DE67B9E140824F1DCDEC400C0F654E8E1D@ORSMSX116.amr.corp.intel.com>
From:   Andy Lutomirski <luto@kernel.org>
Date:   Fri, 24 May 2019 12:37:44 -0700
X-Gmail-Original-Message-ID: <CALCETrUw5sEr-MHPMU4CzEzkrejDs-JOThHB9Buhoxo5-rdpRw@mail.gmail.com>
Message-ID: <CALCETrUw5sEr-MHPMU4CzEzkrejDs-JOThHB9Buhoxo5-rdpRw@mail.gmail.com>
Subject: Re: SGX vs LSM (Re: [PATCH v20 00/28] Intel SGX1 support)
To:     "Xing, Cedric" <cedric.xing@intel.com>
Cc:     "Christopherson, Sean J" <sean.j.christopherson@intel.com>,
        Stephen Smalley <sds@tycho.nsa.gov>,
        Andy Lutomirski <luto@kernel.org>,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        James Morris <jmorris@namei.org>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        LSM List <linux-security-module@vger.kernel.org>,
        Paul Moore <paul@paul-moore.com>,
        Eric Paris <eparis@parisplace.org>,
        "selinux@vger.kernel.org" <selinux@vger.kernel.org>,
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

On Fri, May 24, 2019 at 11:34 AM Xing, Cedric <cedric.xing@intel.com> wrote=
:
>
> > From: linux-sgx-owner@vger.kernel.org [mailto:linux-sgx-
> > owner@vger.kernel.org] On Behalf Of Sean Christopherson
> > Sent: Friday, May 24, 2019 10:55 AM
> >
> > On Fri, May 24, 2019 at 10:42:43AM -0700, Sean Christopherson wrote:
> > > Hmm, I've been thinking more about pulling permissions from the sourc=
e
> > > page.  Conceptually I'm not sure we need to meet the same requirement=
s
> > as
> > > non-enclave DSOs while the enclave is being built, i.e. do we really
> > need
> > > to force userspace to fully map the enclave in normal memory?
> > >
> > > Consider the Graphene scenario where it's building an enclave on the
> > fly.
> > > Pulling permissions from the source VMAs means Graphene has to map th=
e
> > > code pages of the enclave with X.  This means Graphene will need
> > EXEDMOD
> > > (or EXECMEM if Graphene isn't careful).  In a non-SGX scenario this
> > makes
> > > perfect sense since there is no way to verify the end result of RW->R=
X.
> > >
> > > But for SGX, assuming enclaves are whitelisted by their sigstruct
> > (checked
> > > at EINIT) and because page permissions affect sigstruct.MRENCLAVE, it
> > *is*
> > > possible to verify the resulting RX contents.  E.g. for the purposes
> > of
> > > LSMs, can't we use the .sigstruct file as a proxy for the enclave and
> > > require FILE__EXECUTE on the .sigstruct inode to map/run the enclave?
> > >
> > > Stephen, is my logic sound?
> > >
> > >
> > > If so...
> > >
> > >   - Require FILE__READ+FILE__EXECUTE on .sigstruct to mmap() the
> > enclave.
> > >
> > >   - Prevent userspace from mapping the enclave with permissions beyon=
d
> > the
> > >     original permissions of the enclave.  This can be done by
> > populating
> > >     VM_MAY{READ,WRITE,EXEC} from the SECINFO (same basic concept as
> > Andy's
> > >     proposals).  E.g. pre-EINIT, mmap() and mprotect() can only
> > succeed
> > >     with PROT_NONE.
> > >
> > >   - Require FILE__{READ,WRITE,EXECUTE} on /dev/sgx/enclave for
> > simplicity,
> > >     or provide an alternate SGX_IOC_MPROTECT if we want to sidestep
> > the
> > >     FILE__WRITE requirement.
> >
> > One more thought.  EADD (and the equivalent SGX2 flow) could do
> > security_mmap_file() with a NULL file on the SECINFO permissions, which
> > would trigger PROCESS_EXECMEM if an enclave attempts to map a page RWX.
>
> If "initial permissions" for enclaves are less restrictive than shared ob=
jects, then it'd become a backdoor for circumventing LSM when enclave white=
listing is *not* in place. For example, an adversary may load a page, which=
 would otherwise never be executable, as an executable page in EPC.
>
> In the case a RWX page is needed, the calling process has to have a RWX p=
age serving as the source for EADD so PROCESS__EXECMEM will have been check=
ed. For SGX2, changing an EPC page to RWX is subject to FILE__EXECMEM on /d=
ev/sgx/enclave, which I see as a security benefit because it only affects t=
he enclave but not the whole process hosting it.

So the permission would be like FILE__EXECMOD on the source enclave
page, because it would be mapped MAP_ANONYMOUS, PROT_WRITE?
MAP_SHARED, PROT_WRITE isn't going to work because that means you can
modify the file.

I'm starting to think that looking at the source VMA permission bits
or source PTE permission bits is putting a bit too much policy into
the driver as opposed to the LSM.  How about delegating the whole
thing to an LSM hook?  The EADD operation would invoke a new hook,
something like:

int security_enclave_load_bytes(void *source_addr, struct
vm_area_struct *source_vma, loff_t source_offset, unsigned int
maxperm);

Then you don't have to muck with mapping anything PROT_EXEC.  Instead
you load from a mapping of a file and the LSM applies whatever policy
it feels appropriate.  If the first pass gets something wrong, the
application or library authors can take it up with the SELinux folks
without breaking the whole ABI :)

(I'm proposing passing in the source_vma because this hook would be
called with mmap_sem held for read to avoid a TOCTOU race.)

If we go this route, the only substantial change to the existing
driver that's needed for an initial upstream merge is the maxperm
mechanism and whatever hopefully minimal API changes are needed to
allow users to conveniently set up the mappings.  And we don't need to
worry about how to hack around mprotect() calling into the LSM,
because the LSM will actually be aware of SGX and can just do the
right thing.

--Andy
