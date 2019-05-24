Return-Path: <SRS0=Nb5J=TY=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,T_DKIMWL_WL_HIGH,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4DE57C282E1
	for <linux-sgx@archiver.kernel.org>; Fri, 24 May 2019 21:27:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2186C2187F
	for <linux-sgx@archiver.kernel.org>; Fri, 24 May 2019 21:27:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1558733271;
	bh=lYZ/zudY+xu5Tnp4RjFaSiBIAvLoW/eSULQY+XTsmB0=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=qv0Spcb5HE+0Zd5GHzNXKqA6eUPiWe1aTI67sFNpPlV2fy281kza9zG1jjZefUfn+
	 XCWvMbcUfPQoC+uybOi5URs9lVwj9fYlxvbCG25FgRDl5hrCf3LnCfg9Be4rrodB9y
	 SeH9Hvx2X2Oc5viszGgIZPkZxmVK7z3s9/peXu1U=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404176AbfEXV1u (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 24 May 2019 17:27:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:60588 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404276AbfEXV1u (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Fri, 24 May 2019 17:27:50 -0400
Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com [209.85.221.42])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8BCF2218A0
        for <linux-sgx@vger.kernel.org>; Fri, 24 May 2019 21:27:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558733268;
        bh=lYZ/zudY+xu5Tnp4RjFaSiBIAvLoW/eSULQY+XTsmB0=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=0JGJB4h+D9j0ddlAUz9g50NndJ0gLLwGmUqN1hvMw6D4tflMRdf5hZOowZbD/sSk4
         KCsScGmqrRQq0ou0NJ72nJq/c7tzqtrm5Bzvy2ECWR6w/Hnp4SZzlyxpREO3ol6HKy
         VCzEaV6pXU1pu1iXoBn2chS039FLon9BSBUVinwU=
Received: by mail-wr1-f42.google.com with SMTP id u16so7391744wrn.8
        for <linux-sgx@vger.kernel.org>; Fri, 24 May 2019 14:27:48 -0700 (PDT)
X-Gm-Message-State: APjAAAVQEi8fdjRH70Ns4C/LZMhTFi4NB6r2R2Uk4RBMokEB4PYMZLEO
        KTJgMl/uDDcdSFZPh0dciG85IHFDv3YQM0H3ccJqbQ==
X-Google-Smtp-Source: APXvYqz/lEYmDwBnuqtbsvCzNOvsvr/2JBTnsk8u6fRJLIYpjhQwWS2cdjPRGlgRYD7PpvsZVsI0HCybdWBGTpi625c=
X-Received: by 2002:a5d:5506:: with SMTP id b6mr63690967wrv.221.1558733266996;
 Fri, 24 May 2019 14:27:46 -0700 (PDT)
MIME-Version: 1.0
References: <20190523141752.GA12078@linux.intel.com> <CALCETrUzx3LPAKCLFf75P-XshAkRcr+JLET3LA_kHDs9MA11FA@mail.gmail.com>
 <20190523234044.GC12078@linux.intel.com> <CALCETrV4DVEfW6EJ6DnQGGYDJAiA5M1QcuYJTiroumOM+D6Jjg@mail.gmail.com>
 <960B34DE67B9E140824F1DCDEC400C0F654E8956@ORSMSX116.amr.corp.intel.com>
 <dda0912b-cb15-3c07-d368-345159e995f7@tycho.nsa.gov> <20190524174243.GA365@linux.intel.com>
 <20190524175458.GB365@linux.intel.com> <960B34DE67B9E140824F1DCDEC400C0F654E8E1D@ORSMSX116.amr.corp.intel.com>
 <CALCETrUw5sEr-MHPMU4CzEzkrejDs-JOThHB9Buhoxo5-rdpRw@mail.gmail.com> <20190524200333.GF365@linux.intel.com>
In-Reply-To: <20190524200333.GF365@linux.intel.com>
From:   Andy Lutomirski <luto@kernel.org>
Date:   Fri, 24 May 2019 14:27:34 -0700
X-Gmail-Original-Message-ID: <CALCETrUyAAhnQ+RUeN1L41TKj-vcD2CNt-FJ9siO=Zo6gvH1Aw@mail.gmail.com>
Message-ID: <CALCETrUyAAhnQ+RUeN1L41TKj-vcD2CNt-FJ9siO=Zo6gvH1Aw@mail.gmail.com>
Subject: Re: SGX vs LSM (Re: [PATCH v20 00/28] Intel SGX1 support)
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Andy Lutomirski <luto@kernel.org>,
        "Xing, Cedric" <cedric.xing@intel.com>,
        Stephen Smalley <sds@tycho.nsa.gov>,
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
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Fri, May 24, 2019 at 1:03 PM Sean Christopherson
<sean.j.christopherson@intel.com> wrote:
>
> On Fri, May 24, 2019 at 12:37:44PM -0700, Andy Lutomirski wrote:
> > On Fri, May 24, 2019 at 11:34 AM Xing, Cedric <cedric.xing@intel.com> wrote:
> > >
> > > If "initial permissions" for enclaves are less restrictive than shared
> > > objects, then it'd become a backdoor for circumventing LSM when enclave
> > > whitelisting is *not* in place. For example, an adversary may load a page,
> > > which would otherwise never be executable, as an executable page in EPC.
> > >
> > > In the case a RWX page is needed, the calling process has to have a RWX
> > > page serving as the source for EADD so PROCESS__EXECMEM will have been
> > > checked. For SGX2, changing an EPC page to RWX is subject to FILE__EXECMEM
> > > on /dev/sgx/enclave, which I see as a security benefit because it only
> > > affects the enclave but not the whole process hosting it.
> >
> > So the permission would be like FILE__EXECMOD on the source enclave
> > page, because it would be mapped MAP_ANONYMOUS, PROT_WRITE?
> > MAP_SHARED, PROT_WRITE isn't going to work because that means you can
> > modify the file.
>
> Was this in response to Cedric's comment, or to my comment?

Yours.  I think that requiring source pages to be actually mapped W is
not such a great idea.

>
> > I'm starting to think that looking at the source VMA permission bits
> > or source PTE permission bits is putting a bit too much policy into
> > the driver as opposed to the LSM.  How about delegating the whole
> > thing to an LSM hook?  The EADD operation would invoke a new hook,
> > something like:
> >
> > int security_enclave_load_bytes(void *source_addr, struct
> > vm_area_struct *source_vma, loff_t source_offset, unsigned int
> > maxperm);
> >
> > Then you don't have to muck with mapping anything PROT_EXEC.  Instead
> > you load from a mapping of a file and the LSM applies whatever policy
> > it feels appropriate.  If the first pass gets something wrong, the
> > application or library authors can take it up with the SELinux folks
> > without breaking the whole ABI :)
> >
> > (I'm proposing passing in the source_vma because this hook would be
> > called with mmap_sem held for read to avoid a TOCTOU race.)
> >
> > If we go this route, the only substantial change to the existing
> > driver that's needed for an initial upstream merge is the maxperm
> > mechanism and whatever hopefully minimal API changes are needed to
> > allow users to conveniently set up the mappings.  And we don't need to
> > worry about how to hack around mprotect() calling into the LSM,
> > because the LSM will actually be aware of SGX and can just do the
> > right thing.
>
> This doesn't address restricting which processes can run which enclaves,
> it only allows restricting the build flow.  Or are you suggesting this
> be done in addition to whitelisting sigstructs?

In addition.

But I named the function badly and gave it a bad signature, which
confused you.  Let's try again:

int security_enclave_load_from_memory(const struct vm_area_struct
*source, unsigned int maxperm);

Maybe some really fancy future LSM would also want loff_t
source_offset, but it's probably not terribly useful.  This same
callback would be used for EAUG.

Following up on your discussion with Cedric about sigstruct, the other
callback would be something like:

int security_enclave_init(struct file *sigstruct_file);

The main issue I see is that we also want to control the enclave's
ability to have RWX pages or to change a W page to X.  We might also
want:

int security_enclave_load_zeros(unsigned int maxperm);

An enclave that's going to modify its own code will need memory with
maxperm = RWX or WX.

But this is a bit awkward if the LSM's decision depends on the
sigstruct.  We could get fancy and require that the sigstruct be
supplied before any EADD operations so that the maxperm decisions can
depend on the sigstruct.

Am I making more sense now?
