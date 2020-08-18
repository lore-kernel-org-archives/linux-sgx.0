Return-Path: <SRS0=y25d=B4=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 336B8C433DF
	for <linux-sgx@archiver.kernel.org>; Tue, 18 Aug 2020 17:16:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0BA5920786
	for <linux-sgx@archiver.kernel.org>; Tue, 18 Aug 2020 17:16:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597770968;
	bh=dDbjHIlLX5AQ3RPwp120UB+GCmk55w/8ILzYBIzjgOE=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=KGguCABhXGHd81RwOAz+yRkjiBVhs52h1J2VoF4MJceRkwlToKlr0iSw+3+jpE2x0
	 xm9WZXdHoTVZq2ENvxmkCB6NcMN5OM9nnwFTWAkLNhMdN2yoM7xQx+koFApkmf/Nq9
	 NCgo2VZC7urHhS88M71JmJ7N0lrMb0aA9FANeMTA=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727069AbgHRRQH (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 18 Aug 2020 13:16:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:48438 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727061AbgHRRQD (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Tue, 18 Aug 2020 13:16:03 -0400
Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B227E20786
        for <linux-sgx@vger.kernel.org>; Tue, 18 Aug 2020 17:16:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597770963;
        bh=dDbjHIlLX5AQ3RPwp120UB+GCmk55w/8ILzYBIzjgOE=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=Q6FdF+z++xge+w2fyTmt/tqnCdzo7pomVV+L8sUWwHKhspZRrgTVdRu3Y9478K/9E
         VvaqDrx9X4OzeeYv3eTT/EMWSktf8hkuqnEvTq16zmiuxLUjDZcNUzaeOcSs/4AtlN
         Kgp3wrF3t+zAfd4i7d7WdXpGuK25WC6JxRzBMNGU=
Received: by mail-wr1-f45.google.com with SMTP id f1so19007004wro.2
        for <linux-sgx@vger.kernel.org>; Tue, 18 Aug 2020 10:16:02 -0700 (PDT)
X-Gm-Message-State: AOAM53159Qtzy3FZd14D694JgTtIznwf3nT+5VU3oNYBWDc2FaiTdJLi
        oLNsM8L0zrwmW6ioOpQggFlcLfk0/TK81Pk82O8yHg==
X-Google-Smtp-Source: ABdhPJwKxoQhZsU3gmmqzWtxTKNi12WXgC+xbVsq0GPOqH78eWOqEsG6FFQdi6nSyNX7lPFmlie1EqsaFR0bWwVakGY=
X-Received: by 2002:a5d:400e:: with SMTP id n14mr20697166wrp.75.1597770961283;
 Tue, 18 Aug 2020 10:16:01 -0700 (PDT)
MIME-Version: 1.0
References: <20200818042405.12871-1-sean.j.christopherson@intel.com> <20200818042405.12871-5-sean.j.christopherson@intel.com>
In-Reply-To: <20200818042405.12871-5-sean.j.christopherson@intel.com>
From:   Andy Lutomirski <luto@kernel.org>
Date:   Tue, 18 Aug 2020 10:15:49 -0700
X-Gmail-Original-Message-ID: <CALCETrVRAdzFcJOJN6oU1F7hC57zYSmFZi6y2DwhU0sd27FJjQ@mail.gmail.com>
Message-ID: <CALCETrVRAdzFcJOJN6oU1F7hC57zYSmFZi6y2DwhU0sd27FJjQ@mail.gmail.com>
Subject: Re: [RFC PATCH 4/4] x86/vdso: x86/sgx: Allow the user to exit the
 vDSO loop on interrupts
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        Nathaniel McCallum <npmccallum@redhat.com>,
        Cedric Xing <cedric.xing@intel.com>,
        Jethro Beekman <jethro@fortanix.com>, linux-sgx@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Mon, Aug 17, 2020 at 9:24 PM Sean Christopherson
<sean.j.christopherson@intel.com> wrote:
>
> Allow userspace to exit the vDSO on interrupts that are acknowledged
> while the enclave is active.  This allows the user's runtime to switch
> contexts at opportune times without additional overhead, e.g. when using
> an M:N threading model (where M user threads run N TCSs, with N > M).

This is IMO rather odd.  We don't support this type of notification on
interrupts for normal user code.  The fact user code can detect
interrupts during enclave execution is IMO an oddity of SGX, and I
have asked Intel to consider replacing the AEX mechanism with
something more transparent to user mode.  If this ever happens, this
mechanism is toast.

Even without architecture changes, building a *reliable* M:N threading
mechanism on top of this will be difficult or impossible, as there is
no particular guarantee that a thread will get timing interrupts at
all or that these interrupts will get lucky and hit enclave code, thus
triggering an AEX.  We certainly don't, and probably never will,
support any corresponding feature for non-enclave code.

So this seems like an odd, and possibly unsupportable, feature to add.

--Andy
