Return-Path: <SRS0=W/xJ=4V=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,HK_RANDOM_FROM,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E3E7C3F2D1
	for <linux-sgx@archiver.kernel.org>; Wed,  4 Mar 2020 19:51:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0676F21775
	for <linux-sgx@archiver.kernel.org>; Wed,  4 Mar 2020 19:51:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="CdeDNZOD"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387891AbgCDTv4 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 4 Mar 2020 14:51:56 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:42086 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2387847AbgCDTv4 (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Wed, 4 Mar 2020 14:51:56 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583351514;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Ra5c/deVBpeBf2yDXKORW+EsDATadMRlpq+nR2VPF8g=;
        b=CdeDNZOD/wQnlbMqOlwYb1Aq1mMNNllhXnvcFta6F3Fjo4pSTZ9J3wac2dEo6RW0qi4Wen
        LbcW1EUE2kjO1g+i57l8Jf8fHDPHJWs286T2pl/+5izDNiq9wOLbNcAJPhNl5jLojqxgRm
        SA+M7w+ujd3ef9dCdSldxsKTZOcFCNw=
Received: from mail-il1-f200.google.com (mail-il1-f200.google.com
 [209.85.166.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-458-Bgn6jZwgPzqWUZpsp-4EPg-1; Wed, 04 Mar 2020 14:51:51 -0500
X-MC-Unique: Bgn6jZwgPzqWUZpsp-4EPg-1
Received: by mail-il1-f200.google.com with SMTP id l10so2415784ilo.21
        for <linux-sgx@vger.kernel.org>; Wed, 04 Mar 2020 11:51:51 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Ra5c/deVBpeBf2yDXKORW+EsDATadMRlpq+nR2VPF8g=;
        b=k05j+EBdvIXNUeSSgeAchspwpR40bhxnv1zCKZnE+a5SJxPJhQyP0Kh8683CCQcvMX
         BM1d2hNE3cCtQpsYSgFbKApbtAVL9Q8fuaT7/FGv+GWSim4J5lxf0FaAL/NqaW8sG+oz
         71x4cQTDdnb+hONtgWo2ECDa0XHFJ7HKpJD8A5W3Dg0aCAo3vnNaFuVdIFwNVK9o3jpU
         31NPuWRixRP497oO8N3pc/a8x2I/51CbIbZOwMdkaxl17UG1PmrIMRIgu/ewEB99uby3
         DLk1rc5XX+jR5Ucw7aAAunupjW4nvsWddW+meS9Qfw2RbNW8Oe/MKSisUMcqOVIn0eXa
         stIA==
X-Gm-Message-State: ANhLgQ3QAOFcmCV+sZc1W/WL0SdMtIC6bZJEaMcYvaedDrqxF1c9eOEI
        794sXWaxFXS9PFXRQdB+cjNkXyCqN+c/3ztHjVw3OFVFjg2ZThPfxkJ3aVSy0LlAVLHc1wDUoye
        LDp2+8EEoZ6mwMqqf58uSGl2y/H81wIMOb+Ir
X-Received: by 2002:a02:86:: with SMTP id 128mr4197971jaa.3.1583351510744;
        Wed, 04 Mar 2020 11:51:50 -0800 (PST)
X-Google-Smtp-Source: ADFU+vuy4R3WkHiT3ty4P0Jvz03EvpoMWk78M0iocJAbdZEkBb/I6Emb6ZcdDRdLsaS/8iLbqomC7mabXhiUazbqKOw=
X-Received: by 2002:a02:86:: with SMTP id 128mr4197956jaa.3.1583351510519;
 Wed, 04 Mar 2020 11:51:50 -0800 (PST)
MIME-Version: 1.0
References: <20200303233609.713348-1-jarkko.sakkinen@linux.intel.com> <20200303233609.713348-15-jarkko.sakkinen@linux.intel.com>
In-Reply-To: <20200303233609.713348-15-jarkko.sakkinen@linux.intel.com>
From:   Nathaniel McCallum <npmccallum@redhat.com>
Date:   Wed, 4 Mar 2020 14:51:39 -0500
Message-ID: <CAOASepNLGDGZ=9Rx5Pne5oK7QdQ0deonrSsdUKRsv0fzZtx1Eg@mail.gmail.com>
Subject: Re: [PATCH v28 14/22] selftests/x86: Add a selftest for SGX
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     linux-kernel@vger.kernel.org, x86@kernel.org,
        linux-sgx@vger.kernel.org, akpm@linux-foundation.org,
        dave.hansen@intel.com,
        "Christopherson, Sean J" <sean.j.christopherson@intel.com>,
        Neil Horman <nhorman@redhat.com>,
        "Huang, Haitao" <haitao.huang@intel.com>,
        andriy.shevchenko@linux.intel.com, tglx@linutronix.de,
        "Svahn, Kai" <kai.svahn@intel.com>, bp@alien8.de,
        Josh Triplett <josh@joshtriplett.org>, luto@kernel.org,
        kai.huang@intel.com, rientjes@google.com, cedric.xing@intel.com,
        Patrick Uiterwijk <puiterwijk@redhat.com>,
        linux-kselftest@vger.kernel.org
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Tue, Mar 3, 2020 at 6:39 PM Jarkko Sakkinen
<jarkko.sakkinen@linux.intel.com> wrote:
> diff --git a/tools/testing/selftests/x86/sgx/sgx_call.S b/tools/testing/selftests/x86/sgx/sgx_call.S
> new file mode 100644
> index 000000000000..ca4c7893f9d9
> --- /dev/null
> +++ b/tools/testing/selftests/x86/sgx/sgx_call.S
> @@ -0,0 +1,23 @@
> +/* SPDX-License-Identifier: (GPL-2.0 OR BSD-3-Clause) */
> +/**
> +* Copyright(c) 2016-18 Intel Corporation.
> +*/
> +
> +       .text
> +
> +       .macro ENCLU
> +       .byte 0x0f, 0x01, 0xd7
> +       .endm
> +
> +       .text
> +
> +       .global sgx_call_eenter
> +sgx_call_eenter:
> +       push    %rbx
> +       mov     $0x02, %rax
> +       mov     %rdx, %rbx
> +       lea     sgx_async_exit(%rip), %rcx
> +sgx_async_exit:
> +       ENCLU
> +       pop     %rbx
> +       ret

You need to push and pop all the callee-saved registers here since the
enclave zeros them. This code works today by accident. A future
compiler may emit different register allocation which will cause this
to break.

We might consider making it part of the Linux enclave ABI that the
enclave has to save and restore these registers. This would have a
slight performance advantage in a critical code-path compared to
zeroing and then restoring them. But the VDSO code will need to know
what the expectation is.

