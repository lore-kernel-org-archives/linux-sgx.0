Return-Path: <SRS0=jFLL=BU=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BA29EC433DF
	for <linux-sgx@archiver.kernel.org>; Mon, 10 Aug 2020 23:09:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 93022206B2
	for <linux-sgx@archiver.kernel.org>; Mon, 10 Aug 2020 23:09:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597100941;
	bh=KN3dKAif49xXoXcIYO2KHMhCVpVKygWXi9GX3lGZE0Y=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=qb6xHGZ3ye5yWRkGndkErG+VGC0twOaTv+foKdnVyz8Ej94av0TCGsfhYV2ps70dS
	 00Q9dwWZgGEqjjF55o65fF3JMCqe2g4JuMS+WX7EJR4jyDZUajSw7YvjzOUCnj5BTZ
	 +ZEyYNP9UVCq0nxBAs/cXbx9yEP3ivMtYvBESnDo=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727084AbgHJXJB (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 10 Aug 2020 19:09:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:44694 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726722AbgHJXJA (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Mon, 10 Aug 2020 19:09:00 -0400
Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DFB6B207DA
        for <linux-sgx@vger.kernel.org>; Mon, 10 Aug 2020 23:08:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597100940;
        bh=KN3dKAif49xXoXcIYO2KHMhCVpVKygWXi9GX3lGZE0Y=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=Yv2lQ6JaL4P4RZ6DPgVE31ayJe5xrgq8e/gkNH27Ne/wxDKwqPT7kq7bgthZb2324
         lEw+IH7M/ObVNPZdmg3XuvXjJHghj2lvECJhX5M0PTcJY1RU2cHyGjEAvVfdVxynFu
         o179kJE3HAZitPXghelbc7zm8zomnZc/oNMUqjL8=
Received: by mail-wm1-f46.google.com with SMTP id c19so930273wmd.1
        for <linux-sgx@vger.kernel.org>; Mon, 10 Aug 2020 16:08:59 -0700 (PDT)
X-Gm-Message-State: AOAM533u0L5iXCrLp9BIUVzstcEtaRDBYOt2lqOvIHNZZxzyys9X6FIj
        ej1tM2AZGDX3xQj1LrHEbmEPAHvL8U8AFk7Dyc7pCQ==
X-Google-Smtp-Source: ABdhPJxmzhiiwwbrIFHZSor9k9o7ub7q4gaPWRP1byqx4GzUeDDloP6QcQE45NlFyBvtRlFrJIX4xrjlnh1EftzntZU=
X-Received: by 2002:a1c:4c17:: with SMTP id z23mr1361940wmf.49.1597100938325;
 Mon, 10 Aug 2020 16:08:58 -0700 (PDT)
MIME-Version: 1.0
References: <20200716135303.276442-1-jarkko.sakkinen@linux.intel.com>
 <20200716135303.276442-22-jarkko.sakkinen@linux.intel.com> <CAOASepOqRfUafSv_qjUv-jW_6n8G7kZ9yh-2z_Z9sjL_2zqNCg@mail.gmail.com>
In-Reply-To: <CAOASepOqRfUafSv_qjUv-jW_6n8G7kZ9yh-2z_Z9sjL_2zqNCg@mail.gmail.com>
From:   Andy Lutomirski <luto@kernel.org>
Date:   Mon, 10 Aug 2020 16:08:46 -0700
X-Gmail-Original-Message-ID: <CALCETrVch_XW-oc_-LR8Dbgat9DpSKtCYTV9YZaU7tfu61FHEw@mail.gmail.com>
Message-ID: <CALCETrVch_XW-oc_-LR8Dbgat9DpSKtCYTV9YZaU7tfu61FHEw@mail.gmail.com>
Subject: Re: [PATCH v36 21/24] x86/vdso: Implement a vDSO for Intel SGX
 enclave call
To:     Nathaniel McCallum <npmccallum@redhat.com>
Cc:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        X86 ML <x86@kernel.org>, linux-sgx@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Jethro Beekman <jethro@fortanix.com>,
        Cedric Xing <cedric.xing@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        asapek@google.com, Borislav Petkov <bp@alien8.de>,
        chenalexchen@google.com, Conrad Parker <conradparker@google.com>,
        cyhanish@google.com, Dave Hansen <dave.hansen@intel.com>,
        "Huang, Haitao" <haitao.huang@intel.com>,
        Josh Triplett <josh@joshtriplett.org>,
        "Huang, Kai" <kai.huang@intel.com>,
        "Svahn, Kai" <kai.svahn@intel.com>, Keith Moyer <kmoy@google.com>,
        Christian Ludloff <ludloff@google.com>,
        Andrew Lutomirski <luto@kernel.org>,
        Neil Horman <nhorman@redhat.com>,
        Patrick Uiterwijk <puiterwijk@redhat.com>,
        David Rientjes <rientjes@google.com>,
        Thomas Gleixner <tglx@linutronix.de>, yaozhangx@google.com
Content-Type: text/plain; charset="UTF-8"
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Thu, Aug 6, 2020 at 7:55 AM Nathaniel McCallum <npmccallum@redhat.com> wrote:
>
> In a past revision of this patch, I had requested a void *misc
> parameter that could be passed through vdso_sgx_enter_enclave_t into
> sgx_enclave_exit_handler_t. This request encountered some push back
> and I dropped the issue. However, I'd like to revisit it or something
> similar.

Why do you need an exit handler at all?  IIRC way back when I
suggested that we simply not support it at all.  If you want to
call__vdso_sgx_enter_enclave() in a loop, call it in a loop.  If you
want to wrap it intelligently in Rust, you don't want a callback
anyway -- that forces you have an FFI (or non-Rust, anyway) frame on
the stack, which interacts poorly with panic handling and prevents you
from using await in your Rust callback handler.  If, on the other
hand, you just call __vdso_sg_enter_enclave() in a loop, all these
problems go away and, if you really want, you can pass in a callback
in Rust and call the callback from Rust.

What am I missing?  I still don't really understand why we are
supporting this mechanism at all.  Just the asm code to invoke the
callback seems to be about half of the entire function.
