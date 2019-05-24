Return-Path: <SRS0=Nb5J=TY=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,T_DKIMWL_WL_HIGH,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9CA34C072B5
	for <linux-sgx@archiver.kernel.org>; Fri, 24 May 2019 19:31:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 755A321850
	for <linux-sgx@archiver.kernel.org>; Fri, 24 May 2019 19:31:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1558726263;
	bh=++eJML+V7at8ynu0Gghi2KtbxEtQiKNCqvYyHJW4D1g=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=ufEHkrAysfyXeIPdQdJKG1mUwt/vpQ109eDpwP8xAkhBWj+U+PwtQQ7FeIh/7vSgX
	 KiuMuCNfnZ0gkCw/BUNBqAS1b00lrA0eytXhUvLTivDlTJ4raNoQ2zXRXmeM84nWPZ
	 wP0dnc4t9q31UXKms/XPhDfIZpWpuSf28+YGE7wI=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732098AbfEXTa7 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 24 May 2019 15:30:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:47510 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727115AbfEXTa6 (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Fri, 24 May 2019 15:30:58 -0400
Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9473121873
        for <linux-sgx@vger.kernel.org>; Fri, 24 May 2019 19:30:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558726257;
        bh=++eJML+V7at8ynu0Gghi2KtbxEtQiKNCqvYyHJW4D1g=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=gpba4nvhqX6NHqtFJ0DX/6Shq7xMP0QKoNvfrDVV3xkDOBWCDw5N6YSWROb4D5Zsd
         YGWK6QSvX2KpgKTRZlio6xCZ0RViGeRa53/YyUp+E/Tfon1Xxt61VpzWYYHwEKOXug
         46je9P+s2sQxCc9G30mS5qMHz5KhkDO05Ar9qt2c=
Received: by mail-wm1-f48.google.com with SMTP id f204so10470827wme.0
        for <linux-sgx@vger.kernel.org>; Fri, 24 May 2019 12:30:57 -0700 (PDT)
X-Gm-Message-State: APjAAAVHhN0IDJr1k5AlbiBGkEx/oZDWoZlIhRLgIHxFO25ZsqKO4sed
        5I/urJFHoL+1xIuyYJTitcgumdM+loLgSvoJRG/xQw==
X-Google-Smtp-Source: APXvYqyLb4T/bZMdmeEdv3r/4ynyWFeM04ByJvHBR7hqFkVePfmxiSgk3D8BRYB56wOHtSETPWa/diJlf770zautMsU=
X-Received: by 2002:a1c:1d4:: with SMTP id 203mr1051004wmb.76.1558726256158;
 Fri, 24 May 2019 12:30:56 -0700 (PDT)
MIME-Version: 1.0
References: <20190523102628.GC10955@linux.intel.com> <20190523141752.GA12078@linux.intel.com>
 <CALCETrUzx3LPAKCLFf75P-XshAkRcr+JLET3LA_kHDs9MA11FA@mail.gmail.com>
 <20190523234044.GC12078@linux.intel.com> <CALCETrV4DVEfW6EJ6DnQGGYDJAiA5M1QcuYJTiroumOM+D6Jjg@mail.gmail.com>
 <960B34DE67B9E140824F1DCDEC400C0F654E8956@ORSMSX116.amr.corp.intel.com>
 <dda0912b-cb15-3c07-d368-345159e995f7@tycho.nsa.gov> <20190524174243.GA365@linux.intel.com>
 <20190524175458.GB365@linux.intel.com> <960B34DE67B9E140824F1DCDEC400C0F654E8E1D@ORSMSX116.amr.corp.intel.com>
 <20190524191344.GD365@linux.intel.com>
In-Reply-To: <20190524191344.GD365@linux.intel.com>
From:   Andy Lutomirski <luto@kernel.org>
Date:   Fri, 24 May 2019 12:30:44 -0700
X-Gmail-Original-Message-ID: <CALCETrVp+r_wz=sOwLC8oW2P54r=sudBtV+J-Ycq_JE2QxwxEQ@mail.gmail.com>
Message-ID: <CALCETrVp+r_wz=sOwLC8oW2P54r=sudBtV+J-Ycq_JE2QxwxEQ@mail.gmail.com>
Subject: Re: SGX vs LSM (Re: [PATCH v20 00/28] Intel SGX1 support)
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     "Xing, Cedric" <cedric.xing@intel.com>,
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
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Fri, May 24, 2019 at 12:13 PM Sean Christopherson
<sean.j.christopherson@intel.com> wrote:
>
> On Fri, May 24, 2019 at 11:34:32AM -0700, Xing, Cedric wrote:
> > > From: linux-sgx-owner@vger.kernel.org [mailto:linux-sgx-
> > > owner@vger.kernel.org] On Behalf Of Sean Christopherson
> > > Sent: Friday, May 24, 2019 10:55 AM

> I don't see a fundamental difference between having RWX in an enclave and
> RWX in normal memory, either way the process can execute arbitrary code,
> i.e. PROCESS__EXECMEM is appropriate.  Yes, an enclave will #UD on certain
> instructions, but that's easily sidestepped by having a trampoline in the
> host (marked RX) and piping arbitrary code into the enclave.  Or using
> EEXIT to do a bit of ROP.

There's a difference, albeit a somewhat weak one, if sigstructs are
whitelisted.  FILE__EXECMOD on
either /dev/sgx/enclave or on the sigstruct is not an entirely crazy
way to express this.
