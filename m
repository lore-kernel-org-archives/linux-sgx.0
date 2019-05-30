Return-Path: <SRS0=2c9w=T6=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,T_DKIMWL_WL_HIGH,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80370C28CC0
	for <linux-sgx@archiver.kernel.org>; Thu, 30 May 2019 16:14:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4BE0223A85
	for <linux-sgx@archiver.kernel.org>; Thu, 30 May 2019 16:14:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1559232865;
	bh=1s8Cs2JQUU40YRbwjNco7sbSB4A0GwXuuKK25BIeJkI=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=LWoN0Dj3vA5II6N17aLIcA4PwAQh30MjePilL5US8NzAC13fgeKux8mLu/qG9n+pV
	 +zMkiS7ac2tFeePwKesD2Owg0WdaHwjWaqp+khxoGCH2BtdW5u6jc0b+dopLb5GXtP
	 AGrsQ6mEOqIEiaG5JVmytrJeC7WRbmX2KynS6j8g=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727536AbfE3QOZ (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 30 May 2019 12:14:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:58018 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725934AbfE3QOY (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 30 May 2019 12:14:24 -0400
Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 991A723BC5
        for <linux-sgx@vger.kernel.org>; Thu, 30 May 2019 16:14:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559232863;
        bh=1s8Cs2JQUU40YRbwjNco7sbSB4A0GwXuuKK25BIeJkI=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=LOS3cgqjfG5W0FZm/Qz1XZmG/YlgzSaxdgHsRQwq/QnlnD1HUg8gidNH1yJwfmh+e
         0iML8AiYJLDzTOOj1WuUu4IAM0dY98JDg5MGKaBFzWQU9SDeh3qRd+0Somqo926KsM
         K7DR7J/t8ClmJRcWWBgLGPM0JmiDHkie0DsFv4Ds=
Received: by mail-wr1-f44.google.com with SMTP id b18so4555872wrq.12
        for <linux-sgx@vger.kernel.org>; Thu, 30 May 2019 09:14:23 -0700 (PDT)
X-Gm-Message-State: APjAAAXvaB0ROnma4XIvzChmaGkRZwMeVr8MwWbTah9KgsU4qin/UGqK
        QHCvfAfIGHctBmUPylCdoSJvY0jK64KtUP6o3eZgrA==
X-Google-Smtp-Source: APXvYqxis8xI59982mu7Yhvv+04e4RgHrrniVwLY5B1ZbAFhCM3Isc04LA54cAB7i14rTn8pfA3Z7xFpjtbLEa0lHWY=
X-Received: by 2002:adf:fe90:: with SMTP id l16mr3106260wrr.221.1559232862193;
 Thu, 30 May 2019 09:14:22 -0700 (PDT)
MIME-Version: 1.0
References: <20190524175458.GB365@linux.intel.com> <960B34DE67B9E140824F1DCDEC400C0F654E8E1D@ORSMSX116.amr.corp.intel.com>
 <CALCETrUw5sEr-MHPMU4CzEzkrejDs-JOThHB9Buhoxo5-rdpRw@mail.gmail.com>
 <20190524200333.GF365@linux.intel.com> <CALCETrUyAAhnQ+RUeN1L41TKj-vcD2CNt-FJ9siO=Zo6gvH1Aw@mail.gmail.com>
 <20190524224107.GJ365@linux.intel.com> <683B5E3D-AFB6-4B45-8D39-B00847312209@amacapital.net>
 <960B34DE67B9E140824F1DCDEC400C0F654E965F@ORSMSX116.amr.corp.intel.com>
 <CALCETrXXVMutX8eZk6nnkOAeS+Tj0sQd0FkW+wk6Rx8hQxCe6w@mail.gmail.com>
 <960B34DE67B9E140824F1DCDEC400C0F654E9824@ORSMSX116.amr.corp.intel.com>
 <20190528202407.GB13158@linux.intel.com> <285f279f-b500-27f0-ab42-fb1dbcc5ab18@tycho.nsa.gov>
 <960B34DE67B9E140824F1DCDEC400C0F654EB487@ORSMSX116.amr.corp.intel.com>
 <678a37af-797d-7bd5-a406-32548a270e3d@tycho.nsa.gov> <CALCETrWXB9fNNDH7gZxPTx05F78Og6K=ZtAr2aA++BDwY09Wbg@mail.gmail.com>
 <c1135352-0b5e-4694-b1a9-105876095877@tycho.nsa.gov>
In-Reply-To: <c1135352-0b5e-4694-b1a9-105876095877@tycho.nsa.gov>
From:   Andy Lutomirski <luto@kernel.org>
Date:   Thu, 30 May 2019 09:14:10 -0700
X-Gmail-Original-Message-ID: <CALCETrWsEXzUC33eJpGCpdMCBO4aYVviZLRD-CLMNaG5Jv-TCA@mail.gmail.com>
Message-ID: <CALCETrWsEXzUC33eJpGCpdMCBO4aYVviZLRD-CLMNaG5Jv-TCA@mail.gmail.com>
Subject: Re: SGX vs LSM (Re: [PATCH v20 00/28] Intel SGX1 support)
To:     Stephen Smalley <sds@tycho.nsa.gov>
Cc:     Andy Lutomirski <luto@kernel.org>,
        "Xing, Cedric" <cedric.xing@intel.com>,
        "Christopherson, Sean J" <sean.j.christopherson@intel.com>,
        William Roberts <bill.c.roberts@gmail.com>,
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

On Thu, May 30, 2019 at 8:04 AM Stephen Smalley <sds@tycho.nsa.gov> wrote:
>
> On 5/30/19 10:31 AM, Andy Lutomirski wrote:
> > Hi all-
> >
> > After an offline discussion with Sean yesterday, here are some updates
> > to the user API parts of my proposal.
> >
> > Unfortunately, Sean convinced me that MAXPERM doesn't work the way I
> > described it because, for SGX2, the enclave loader won't know at load
> > time whether a given EAUG-ed page will ever be executed.  So here's an
> > update.
> >
> > First, here are the requrements as I see them, where EXECUTE, EXECMOD,
> > and EXECMEM could be substituted with other rules at the LSM's
> > discretion:
> >
> >   - You can create a WX or RWX mapping if and only if you have EXECMEM.
> >
> >   - To create an X mapping of an enclave page that has ever been W, you
> > need EXECMOD.
>
> EXECMOD to what file? The enclave file from which the page's content
> originated, the sigstruct file, or /dev/sgx/enclave?

I leave that decision to you :)  The user should need permission to do
an execmod thing on an enclave, however that wants to be encoded.

>
> >   - To create an X mapping of an enclave page that came from EADD, you
> > need EXECUTE on the source file.  Optionally, we could also permit
> > this if you have EXECMOD.
>
> What is the "source file" i.e. the target of the check?  Enclave file,
> sigstruct file, or /dev/sgx/enclave?

Enclave file -- that is, the file backing the vma from which the data is loaded.

>
> >
> > And I have two design proposals.  One is static and one is dynamic.
> > To implement either one, we will probably need a new .may_mprotect vm
> > operation, and that operation can call an LSM hook.  Or we can give
> > LSMs a way to detect that a given vm_area_struct is an enclave.  As I
> > see it, this is an implementation detail that is certainly solveable.
> >
> >
> > Static proposal:
> >
> >
> > EADD takes an execute_intent flag.  It calls a new hook:
> >
> >    int security_enclave_load(struct vm_area_struct *source, bool execute_intent);
> >
> > This hook will fail if execute_intent==true and the caller has neither
> > EXECUTE, EXECMOD, nor EXECMEM.
>
> EADD execute_intent flag is originally provided by whom (userspace or
> driver) on what basis? Which file is referenced by source->vm_file? Why
> trigger all three checks up front versus only checking if needed?  Won't
> this trigger a lot of unnecessary EXECMOD and EXECMEM denials that will
> need to be dontaudit'd? What if there is a mismatch between
> execute_intent and the initial permissions?

It's provided by userspace based on whether it thinks the data in
question is enclave code.  source->vm_file is the file from which the
code is being loaded.  I'm assuming that the user code will only set
excute_intent ==true if it actually wants to execute the code, so, if
there's a denial, it will be fatal.  The normal case will be that the
request will be granted on the basis of EXECUTE.

>
> >
> > EAUG sets execute_intent = false.
> >
> > EINIT takes a sigstruct pointer.  SGX can (when initially upstreamed
> > or later on once there's demand) call a new hook:
> >
> >    security_enclave_init(struct sigstruct *sigstruct, struct
> > vm_area_struct *source);
>
> Is struct sigstruct the same as struct sgx_sigstruct in the current
> patches (i.e. just the sigstruct data, no file)?  What file is
> referenced by source->vm_file (the sigstruct or the enclave or
> /dev/sgx/enclave)?  Is this hook only for enforcing a whitelist on what
> enclaves can be loaded?  What is the target of the check?

sigstruct is just the data.  source->vm_file is the file from which
the sigstruct came, which could be a .sigstruct file or could be the
main executable or a DSO that contains an embedded enclave.  The
sigstruct data is there so that an LSM (not necessarily SELinux) could
check MRENCLAVE or MRSIGNER, and the source is there so that the
file's label can be checked.

>
> > mmap() and mprotect() will require EXECMEM to create WX or RWX
> > mappings.  They will require EXECMOD to create RX or X mappings of an
> > execute_intent==false page.  They require no permissions in the other
> > cases.
>
> Does this occur for both setting initial permissions and runtime
> permissions or just runtime? Both userspace- and driver-initiated
> mmap/mprotect operations or just userspace-initiated ones?  Does the
> driver use interfaces that call the mmap/mprotect hooks or lower level
> functions?

These would occur for any mmap(), mprotect(), or ioctl() that changes
VMA permissions.  Actually arranging for the hooks to be called is an
implementation detail that might require a new .mprotect vm_operation.
As an alternative, security_enclave_init() or similar could supply
may_execmod and may_execmem flags to the driver, and the driver could
do these checks on its own when mmap() and mprotect() happen without a
new LSM callback.

>
> >
> >
> > Dynamic proposal:
> >
> >
> > EADD does not take any special flags.  It does something like this internally:
> >
> >    bool execute_intent = true;
> >    int security_enclave_load(struct vm_area_struct *source, bool
> > *execute_intent);
> >
> > The implementation of security_enclave_load() may set *execute_intent to false.
> > The driver records execute_intent after the LSM is done.
>
> On what basis does LSM decide whether to set *execute_intent?  If the
> process lacks all three permissions? What if there is a mismatch with
> the initial permissions?
>

I think it would set *execute_intent=false if the process lacks
EXECUTE on source->vm_file.  I'm not sure any more complexity is
required.  If the enclave has EXECMOD, then it will still work on the
basis of the mmap/mprotect rules.

> >
> > mmap() and mprotect() will require EXECMEM to create WX or RWX
> > mappings.  They will require EXECMOD to create RX or X mappings of an
> > execute_intent==false page.  They require no permissions in the other
> > cases.
> >
> >
> >
> > A benefit of the static proposal is that audit failures due to a lack
> > of EXECUTE permission are easy to implement and to understand in the
> > lods.  With the dynamic model, we can only really audit the lack of
> > EXECMOD or EXECMEM.  A benefit of the dynamic model is that we hide
> > what is arguably a decently large wart from the API.
> >
>
