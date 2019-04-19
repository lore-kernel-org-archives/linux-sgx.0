Return-Path: <SRS0=cz4p=SV=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.2 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4FE4C282DF
	for <linux-sgx@archiver.kernel.org>; Fri, 19 Apr 2019 18:35:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B4F6720449
	for <linux-sgx@archiver.kernel.org>; Fri, 19 Apr 2019 18:35:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1555698954;
	bh=J99gtRrJI/sxcUDI9VlJ1PuPq+LCWVlFaN+rk+m4zTo=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=IhiIz2DsWYv4WIQXCFwoGYRUpOgjzO/IdaOZfEhxCfY6y/o4TCaRm1GgdlJRMaCXG
	 7jOEJFSlYDXIBWSrzqoRNiLbVJ2OewSj5FC5MVXm9qfoBQldFiK7znCXLk6DibfJTw
	 ZV2NvOdSJkPON/J7KZPGiToVR7irLSRnw2SS6h+g=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727782AbfDSSfZ (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 19 Apr 2019 14:35:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:53864 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726718AbfDSS3P (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Fri, 19 Apr 2019 14:29:15 -0400
Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9B46A222D7
        for <linux-sgx@vger.kernel.org>; Fri, 19 Apr 2019 15:27:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1555687659;
        bh=J99gtRrJI/sxcUDI9VlJ1PuPq+LCWVlFaN+rk+m4zTo=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=JT/dgZk3rOO5n7351+3P3Z75wCkW4+pDfvuRf2y+ZvwTp1Ci//z0B8R98N7KctZ2r
         LwjkJJvE3kqnNiuKUMx2wX7wFImJ36bK4paw/QitG+/sjZz2l5/VjPWbiFcmECwmer
         5q/C6BBomFNha5w9c4incg9nkLu8LQ3DMUMQ6gsI=
Received: by mail-wm1-f51.google.com with SMTP id z11so6652459wmi.0
        for <linux-sgx@vger.kernel.org>; Fri, 19 Apr 2019 08:27:39 -0700 (PDT)
X-Gm-Message-State: APjAAAUoLrYRIE9C1QQrtfwFH/EGWHuehpk8k9zBFecNaA9oMpt2LY1W
        ewWQUdcsyGoehWeRp0kJ2f3mLh7YQ0FH62RflB0iGA==
X-Google-Smtp-Source: APXvYqwI3uOAyu8SJANJhLDlXWc7HzYIiBKPeh6iojSffO9u82u2RIzp8cFLlCbu2W5uAeQNPaxb7J3Sl1r5rUat1FQ=
X-Received: by 2002:a1c:eb18:: with SMTP id j24mr3240691wmh.32.1555687658136;
 Fri, 19 Apr 2019 08:27:38 -0700 (PDT)
MIME-Version: 1.0
References: <20190417103938.7762-1-jarkko.sakkinen@linux.intel.com>
 <20190418171059.GA20819@wind.enjellic.com> <09ebfa1d-c03d-c1fe-ff0f-d99287b6ec3c@intel.com>
 <20190419141732.GA2269@wind.enjellic.com>
In-Reply-To: <20190419141732.GA2269@wind.enjellic.com>
From:   Andy Lutomirski <luto@kernel.org>
Date:   Fri, 19 Apr 2019 08:27:26 -0700
X-Gmail-Original-Message-ID: <CALCETrV=wAsyWxtxQJ7y0xNrzkE863hTfU6Ysej48Gk9yPFJZw@mail.gmail.com>
Message-ID: <CALCETrV=wAsyWxtxQJ7y0xNrzkE863hTfU6Ysej48Gk9yPFJZw@mail.gmail.com>
Subject: Re: [PATCH v20 00/28] Intel SGX1 support
To:     "Dr. Greg" <greg@enjellic.com>
Cc:     Dave Hansen <dave.hansen@intel.com>,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, X86 ML <x86@kernel.org>,
        linux-sgx@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        "Christopherson, Sean J" <sean.j.christopherson@intel.com>,
        nhorman@redhat.com, npmccallum@redhat.com,
        "Ayoun, Serge" <serge.ayoun@intel.com>,
        "Katz-zamir, Shay" <shay.katz-zamir@intel.com>,
        "Huang, Haitao" <haitao.huang@intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Svahn, Kai" <kai.svahn@intel.com>, Borislav Petkov <bp@alien8.de>,
        Josh Triplett <josh@joshtriplett.org>,
        Andrew Lutomirski <luto@kernel.org>,
        "Huang, Kai" <kai.huang@intel.com>,
        David Rientjes <rientjes@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

> On Apr 19, 2019, at 7:17 AM, Dr. Greg <greg@enjellic.com> wrote:
>
> On Thu, Apr 18, 2019 at 11:01:00AM -0700, Dave Hansen wrote:

> "The value of Intel SGX is to execute code in a protected enclave;
> however, Intel SGX does not guarantee that the code executed in the
> enclave is from a trusted source.  In all cases, we recommend
> utilizing programs, files, apps and plugins from trusted sources,"
> Intel said.

Linux *has* mechanisms to enforce the provenance of code, and they
have nothing to do with SGX.  Off the top of my head, there=E2=80=99s IMA,
SELinux (depending on policy), and dm-verity.

So it seems to me that our bases are already pretty well covered. I
see two cases where some additional protection for SGX might make
sense:

1. You care more about the provenance of enclaves than the provenance
of normal code.  (=E2=80=9CYou=E2=80=9D is the platform owner, not a remote=
 party
verifying SGX quotes.=E2=80=9D) There are any number of solutions that coul=
d
work here, and not all of them involve crypto.

2. You care about the case where the kernel is compromised.  In this
case, nothing that's been discussed helps much on an FLC system, and
even the pre-LC systems aren't a whole lot better given the lack of
init token revocation.

But I think we may be missing a much bigger issue that does need
consideration before the driver gets merged.  We're all focusing on
*additional* SGX protections, but I'm not even sure we have the SGX
protections up to snuff with the rest of the system.  There are many,
many Linux systems that enforce a policy that *all* executable text
needs to come from a verified source.  On these systems, you can't
mmap some writable memory, write to it, and then change it to
executable.  (Obviously, JITs either don't work or need special
permissions on these systems.)

Unless I'm missing it, the current SGX API is entirely incompatible
with this model -- the host process supplies text *bytes* to the
kernel, and the kernel merrily loads those bytes into executable
enclave memory.  Whoops!

I think we may need to change the API so that enclaves are loaded from
a file where the contents of the file are in some appropriate format.
(The file should, at least, contain MRENCLAVE, but various antivirus
tools would much prefer if the actual enclave contents were in the
file.)  It's not entirely clear that the enclave text and data need to
be in the file, since they're covered by the hash.)  Then, to start an
enclave, you pass an fd to the file to the SGX driver, and the SGX
driver parses out the relevant data initializes the enclave.  Before
this happens, the driver could call into IMA and LSM hooks, and the
driver would also verify that the file didn't come from a noexec
filesystem.

I suppose another approach would be to treat SGX the same way that
ld.so is treated, mostly by requiring that the buffers passed to the
driver that contain text be marked executable.  This seems quite a bit
weakter to me.

What do you all think?
