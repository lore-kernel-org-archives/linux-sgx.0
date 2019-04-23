Return-Path: <SRS0=01IT=SZ=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B7BC0C10F11
	for <linux-sgx@archiver.kernel.org>; Tue, 23 Apr 2019 01:29:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 58A4720859
	for <linux-sgx@archiver.kernel.org>; Tue, 23 Apr 2019 01:29:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1555982961;
	bh=rvvCXm3NyxcvTskwYMP3xXvK0tJlFtzpbaQipvChvCs=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=UrafsNJCAECClnZwcVH+m/BD6e2XaBivSDdyWsJkSGT4L32T5qkB9QPrJaRa2JlhR
	 ZiOkYlqhwk5WtSCHA5Xc2qFjhbI7Q9muPeEl3lvZKvrCigN1qRIOYWVOUfiE2AMSZs
	 UfRvawx4Y0OTt9urGTN1dyTkvAEKgFHeWD+K+FMs=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728178AbfDWB3V (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 22 Apr 2019 21:29:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:39044 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727274AbfDWB3U (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Mon, 22 Apr 2019 21:29:20 -0400
Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B47B3218DA
        for <linux-sgx@vger.kernel.org>; Tue, 23 Apr 2019 01:29:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1555982959;
        bh=rvvCXm3NyxcvTskwYMP3xXvK0tJlFtzpbaQipvChvCs=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=aSGVN8lrFJFVCqZG3Cwa8HwPqUbQeuTXHU5a14kpoVmKF5RRMNMelHOdg8DKEJybF
         4f2w/V5O5AWtuBAPtse2H2uZdvNN8vOXSOmISQYTG4crIgXytNi0nTqJkysz2ZPYkr
         79l+x6/5ZLvDL8M5tIMW5x5vnaM9Q3cuOOGE1rho=
Received: by mail-wm1-f49.google.com with SMTP id h18so16530897wml.1
        for <linux-sgx@vger.kernel.org>; Mon, 22 Apr 2019 18:29:19 -0700 (PDT)
X-Gm-Message-State: APjAAAXtnhnkHoR9NBgUHncNTA1seSNztFHSdViLYIQf3u8/wtl5a+4u
        +Y6p6xYOBE0CCt8iIylFluLV8Wq6XFciUtnUjozW+A==
X-Google-Smtp-Source: APXvYqyRpmqrj25YGwsG52rc/ODhPZgpW6hJPeKuhMcnfRVNkiihNrpr/DJVl8UmWK1Xcb6S8IedyRcRWuDxo2vgfbs=
X-Received: by 2002:a1c:eb18:: with SMTP id j24mr230176wmh.32.1555982958011;
 Mon, 22 Apr 2019 18:29:18 -0700 (PDT)
MIME-Version: 1.0
References: <20190417103938.7762-1-jarkko.sakkinen@linux.intel.com>
 <cover.1555965327.git.cedric.xing@intel.com> <f82e81c9cae31634684964d3fc4e9637e7565c69.1555965327.git.cedric.xing@intel.com>
In-Reply-To: <f82e81c9cae31634684964d3fc4e9637e7565c69.1555965327.git.cedric.xing@intel.com>
From:   Andy Lutomirski <luto@kernel.org>
Date:   Mon, 22 Apr 2019 18:29:06 -0700
X-Gmail-Original-Message-ID: <CALCETrWpMxoX00SfnCgYdNbT5JmnzHNJ+73NmUjebBEjk7DuJA@mail.gmail.com>
Message-ID: <CALCETrWpMxoX00SfnCgYdNbT5JmnzHNJ+73NmUjebBEjk7DuJA@mail.gmail.com>
Subject: Re: [RFC PATCH v1 3/3] selftests/x86: Augment SGX selftest to test
 new __vdso_sgx_enter_enclave() and its callback interface
To:     Cedric Xing <cedric.xing@intel.com>
Cc:     LKML <linux-kernel@vger.kernel.org>, X86 ML <x86@kernel.org>,
        linux-sgx@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Dave <dave.hansen@intel.com>,
        Sean J <sean.j.christopherson@intel.com>, nhorman@redhat.com,
        npmccallum@redhat.com, Serge <serge.ayoun@intel.com>,
        Shay <shay.katz-zamir@intel.com>,
        Haitao <haitao.huang@intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Kai <kai.svahn@intel.com>, Borislav Petkov <bp@alien8.de>,
        Josh Triplett <josh@joshtriplett.org>,
        Andrew Lutomirski <luto@kernel.org>, Kai <kai.huang@intel.com>,
        David Rientjes <rientjes@google.com>,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Mon, Apr 22, 2019 at 5:37 PM Cedric Xing <cedric.xing@intel.com> wrote:
>
> Given the changes to __vdso_sgx_enter_enclave(), the selftest is augmented to
> test the newly added callback interface. This addtional test marks the whole
> enclave range as PROT_READ, and calls mprotect() upon #PFs to add necessary PTE
> permissions per PFEC (#PF Error Code) until the enclave finishes.

Nifty.

What's not tested here is running this code with EFLAGS.TF set and
making sure that it unwinds correctly.  Also, Jarkko, unless I missed
something, the vDSO extable code likely has a bug.  If you run the
instruction right before ENCLU with EFLAGS.TF set, then do_debug()
will eat the SIGTRAP and skip to the exception handler.  Similarly, if
you put an instruction breakpoint on ENCLU, it'll get skipped.  Or is
the code actually correct and am I just remembering wrong?

--Andy
