Return-Path: <SRS0=qw+Y=UF=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,T_DKIMWL_WL_HIGH,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B7821C04AB5
	for <linux-sgx@archiver.kernel.org>; Thu,  6 Jun 2019 17:20:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 873082083E
	for <linux-sgx@archiver.kernel.org>; Thu,  6 Jun 2019 17:20:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1559841652;
	bh=fAHawjYvH7hYSCgAPU5bBzt1CjEZkiQibWVpMLEiyAw=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=EF9nSKZ9263CDjjvze6m3BbaW48kMOLSiTC1sADsC3D56mgdG7zu1OWqRwCIGVjFO
	 yjEv7NX0hFZzJyGe6vdsTD1VWJzUPMWBMIxhr1j7+x3LpBU1vW9iGGo+Mf1erDicqV
	 6CZagai6rvVvdwKvYEvnHfKF8cM2iZDHW26iYUas=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726693AbfFFRUw (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 6 Jun 2019 13:20:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:52018 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730076AbfFFRUw (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 6 Jun 2019 13:20:52 -0400
Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2D43D208E3
        for <linux-sgx@vger.kernel.org>; Thu,  6 Jun 2019 17:20:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559841651;
        bh=fAHawjYvH7hYSCgAPU5bBzt1CjEZkiQibWVpMLEiyAw=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=BhR/shOtjv0kb/B1uVcKAW2eFf8FMgZRNokd1XsuDnjx9y6hQNlrs5AgIsKImoCea
         StxiI1Wcq+68V4CZMI2dmaYGjO91KeGSbh+8zw5IRUzVBBjbauSAUiM40Y4dabBAw+
         4C25Cpb7LO0tVK5R1EMU9Oda8X+KSp1sHIyFsdLQ=
Received: by mail-wr1-f49.google.com with SMTP id r18so3246783wrm.10
        for <linux-sgx@vger.kernel.org>; Thu, 06 Jun 2019 10:20:51 -0700 (PDT)
X-Gm-Message-State: APjAAAXV81IUM9NEdbVfpqmxXGz8gs0AR65FpVtcGK0wdF2lfRSRwQ2U
        TdlgpVgu31cj0EECW2I/pbayMf4rk3T3KbYnNp4N3g==
X-Google-Smtp-Source: APXvYqwzhU5xpB16DdWyuWpO74rigozMucemDzGgW6f6V81MnfGxbnTs0rAr5NbE6+wqOAyVw7yf2nWTgGbJBHsnYWM=
X-Received: by 2002:adf:cc85:: with SMTP id p5mr15583434wrj.47.1559841649707;
 Thu, 06 Jun 2019 10:20:49 -0700 (PDT)
MIME-Version: 1.0
References: <20190605194845.926-1-sean.j.christopherson@intel.com> <20190605194845.926-6-sean.j.christopherson@intel.com>
In-Reply-To: <20190605194845.926-6-sean.j.christopherson@intel.com>
From:   Andy Lutomirski <luto@kernel.org>
Date:   Thu, 6 Jun 2019 10:20:38 -0700
X-Gmail-Original-Message-ID: <CALCETrXkWHOFUD0erQ+TZMY3VmGJz8=tk9rXOtdi8fP_GDEKCA@mail.gmail.com>
Message-ID: <CALCETrXkWHOFUD0erQ+TZMY3VmGJz8=tk9rXOtdi8fP_GDEKCA@mail.gmail.com>
Subject: Re: [PATCH 5/7] x86/sgx: Add flag to zero added region instead of
 copying from source
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        linux-sgx@vger.kernel.org, Dave Hansen <dave.hansen@intel.com>,
        Cedric Xing <cedric.xing@intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Jethro Beekman <jethro@fortanix.com>,
        "Dr . Greg Wettstein" <greg@enjellic.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Wed, Jun 5, 2019 at 12:49 PM Sean Christopherson
<sean.j.christopherson@intel.com> wrote:
>
> For some enclaves, e.g. an enclave with a small code footprint and a
> large working set, the vast majority of pages added to the enclave are
> zero pages.  Introduce a flag to denote such zero pages.  The major
> benefit of the flag will be realized in a future patch to use Linux's
> actual zero page as the source, as opposed to explicitly zeroing the
> enclave's backing memory.
>

I feel like I probably asked this at some point, but why is there a
workqueue here at all?
