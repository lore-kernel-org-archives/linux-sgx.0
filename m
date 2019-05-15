Return-Path: <SRS0=97/O=TP=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58BADC04E53
	for <linux-sgx@archiver.kernel.org>; Wed, 15 May 2019 23:13:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0AC1F2084E
	for <linux-sgx@archiver.kernel.org>; Wed, 15 May 2019 23:13:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1557962015;
	bh=oXIRUhaHoitttMrIPB2rv0mrXlZVPITnJpfkP2WGxVA=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=RuK92l2htm6Zy6ENDQ/L4KARkXSZRt1AQfg8n5wk0WfQMJ2IouADN6aYuujj6pma5
	 2tUb/RXUGzaJzSDfc5Q0NR5GnVxg3SqxmjFW/DDCmqphOza0CfLMEXc8WSEp/YVEIF
	 w5KSXjckizPuRVfhpB3JsKQeIZoI3wtsYRyI8mCs=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725953AbfEOXNa (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 15 May 2019 19:13:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:41594 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726380AbfEOXNa (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 15 May 2019 19:13:30 -0400
Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E4CEC21726
        for <linux-sgx@vger.kernel.org>; Wed, 15 May 2019 23:13:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557962009;
        bh=oXIRUhaHoitttMrIPB2rv0mrXlZVPITnJpfkP2WGxVA=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=VbF8Ip5K02eLqRuNtSS6WygUsSTTLfyAYn9NcN3u9GKSyhtm3+BN8zkh35/Dq8Ekl
         BLooL6ayE6/H0fEyV9VadrhQFqHsDyCMtDszV2imLL0hKb1Cba9BH4ZcIchASyFnVv
         uYGJFISNfE49xSl0pLPqhJzxWUFndnszyL6u0ULw=
Received: by mail-wr1-f49.google.com with SMTP id h4so1230991wre.7
        for <linux-sgx@vger.kernel.org>; Wed, 15 May 2019 16:13:28 -0700 (PDT)
X-Gm-Message-State: APjAAAUyHEAogPf7N8Y0B6szwLKEBpU6IgheZs9TkU30PX2iFvBeA9w0
        FG3jC076gAmjqwTPI5+g7m24oLyZ8DiEyAjmbbKkmA==
X-Google-Smtp-Source: APXvYqx8WK5Hi6FoJcSd9VsW2VbRkOOSjlnlo07tWriqsFOxSCmdirUQKhI03vZN1Sh8qXdY8fD30ruPZx0us0bAMz4=
X-Received: by 2002:adf:fb4a:: with SMTP id c10mr26918322wrs.309.1557962007443;
 Wed, 15 May 2019 16:13:27 -0700 (PDT)
MIME-Version: 1.0
References: <8fe520bb-30bd-f246-a3d8-c5443e47a014@intel.com>
 <358e9b36-230f-eb18-efdb-b472be8438b4@fortanix.com> <960B34DE67B9E140824F1DCDEC400C0F4E886094@ORSMSX116.amr.corp.intel.com>
 <6da269d8-7ebb-4177-b6a7-50cc5b435cf4@fortanix.com> <CALCETrWCZQwg-TUCm58DVG43=xCKRsMe1tVHrR8vdt06hf4fWA@mail.gmail.com>
 <20190513102926.GD8743@linux.intel.com> <20190514104323.GA7591@linux.intel.com>
 <CALCETrVbgTCnPo=PAq0-KoaRwt--urrPzn==quAJ8wodCpkBkw@mail.gmail.com>
 <20190514204527.GC1977@linux.intel.com> <CALCETrX6aL367mMJh5+Y1Seznfu-AvhPV6P7GkWF4Dhu0GV8cw@mail.gmail.com>
 <20190515013031.GF1977@linux.intel.com> <CALCETrXf8mSK45h7sTK5Wf+pXLVn=Bjsc_RLpgO-h-qdzBRo5Q@mail.gmail.com>
 <alpine.LRH.2.21.1905160543070.19802@namei.org> <CALCETrX_Q6qwNRNF0TL2tgfm1j6DKLX7NVHHmWbMFtk3WnHDKw@mail.gmail.com>
 <alpine.LRH.2.21.1905160844130.29250@namei.org>
In-Reply-To: <alpine.LRH.2.21.1905160844130.29250@namei.org>
From:   Andy Lutomirski <luto@kernel.org>
Date:   Wed, 15 May 2019 16:13:15 -0700
X-Gmail-Original-Message-ID: <CALCETrX2ovRx3Rre+1_xC-q6CiybyLjQ-gmB4FZF_qCZ-Qd+4A@mail.gmail.com>
Message-ID: <CALCETrX2ovRx3Rre+1_xC-q6CiybyLjQ-gmB4FZF_qCZ-Qd+4A@mail.gmail.com>
Subject: Re: SGX vs LSM (Re: [PATCH v20 00/28] Intel SGX1 support)
To:     James Morris <jmorris@namei.org>
Cc:     Andy Lutomirski <luto@kernel.org>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        LSM List <linux-security-module@vger.kernel.org>,
        Paul Moore <paul@paul-moore.com>,
        Stephen Smalley <sds@tycho.nsa.gov>,
        Eric Paris <eparis@parisplace.org>, selinux@vger.kernel.org,
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
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Wed, May 15, 2019 at 3:46 PM James Morris <jmorris@namei.org> wrote:
>
> On Wed, 15 May 2019, Andy Lutomirski wrote:
>
> > > Why not just use an xattr, like security.sgx ?
> >
> > Wouldn't this make it so that only someone with CAP_MAC_ADMIN could
> > install an enclave?  I think that this decision should be left up the
> > administrator, and it should be easy to set up a loose policy where
> > anyone can load whatever enclave they want.  That's what would happen
> > in my proposal if there was no LSM loaded or of the LSM policy didn't
> > restrict what .sigstruct files were acceptable.
> >
>
> You could try user.sigstruct, which does not require any privs.
>

I don't think I understand your proposal.  What file would this
attribute be on?  What would consume it?

I'm imagining that there's some enclave in a file
crypto_thingy.enclave.  There's also a file crypto_thingy.sigstruct.
crypto_thingy.enclave has type lib_t or similar so that it's
executable.  crypto_thingy.sigstruct has type sgx_sigstruct_t.  The
enclave loader does, in effect:

void *source_data = mmap(crypto_thingy.enclave, PROT_READ | PROT_EXEC, ...);
int sigstruct_fd = open("crypto_thingy.sigstruct", O_RDONLY);
int enclave_fd = open("/dev/sgx/enclave", O_RDWR);

ioctl(enclave_fd, SGX_IOC_ADD_SOME_DATA, source_data + source_offset,
enclave_offset, len, ...);
ioctl(enclave_fd, SGX_IOC_ADD_SOME_DATA, source_data + source_offset2,
enclave_offset2, len, ...);
etc.

/* Here's where LSMs get to check that the sigstruct is acceptable.
The CPU will check that the sigstruct matches the enclave. */
ioctl(enclave_fd, SGX_INIT_THE_ENCLAVE, sigstruct_fd);

/* Actually map the thing */
mmap(enclave_fd RO section, PROT_READ, ...);
mmap(enclave_fd RW section, PROT_READ | PROT_WRITE, ...);
mmap(enclave_fd RX section, PROT_READ | PROT_EXEC, ...);

/* This should fail unless EXECMOD is available, I think */
mmap(enclave_fd RWX section, PROT_READ | PROT_WRITE | PROT_EXEC);

And the idea here is that, if the .enclave file isn't mapped
PROT_EXEC, then mmapping the RX section will also require EXECMEM or
EXECMOD.
