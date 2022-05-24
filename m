Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1CFDBC433EF
	for <linux-sgx@archiver.kernel.org>; Tue, 24 May 2022 19:15:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233786AbiEXTPG (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 24 May 2022 15:15:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232102AbiEXTPF (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Tue, 24 May 2022 15:15:05 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E699F5DE48
        for <linux-sgx@vger.kernel.org>; Tue, 24 May 2022 12:15:03 -0700 (PDT)
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1653419701;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=+tl3R4gEXc2j1i6TLarzMGnu1xDmmCKf3MnW6uhtMYI=;
        b=24xTbusj0zIcTFv1pYkbwnU3VsjXBZMN3JdgKktLtEdZktLaqRkrnz8QahMf2UjVwJp32F
        h9G6VVXX/9gT7n3RmKUjpCYVEYjF50jzipWwvT2JkynEHpEk1DcKWpdqc6f6yybjB26jHy
        4+Yk0f8UYJTqqNd3JOL3iCohMRCHw43oH5rdPm+XVx58tXnoxcLeF4Pq4xZ5RNusYBFVxV
        cSwAm3X1eld7ILbDc6O3Xt4L9mdOXzfT+7ge9y8uSjgtlccjvFB0cqUZNnPCiTXLgBESMP
        EKEWEUH+T0h7szsNY/aql3q9UTuDL2N1K75rQSwECHQk0UndiS8T7idTSIGf7Q==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1653419701;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=+tl3R4gEXc2j1i6TLarzMGnu1xDmmCKf3MnW6uhtMYI=;
        b=//H98QCTdlJUeozhw7kyybAsVtIq37qDmK9xOQKCQ6opENK7J3OO2sr+i0mFT2v7LT7rDw
        P6FvfyVHWUO6D4Bg==
To:     Cathy Zhang <cathy.zhang@intel.com>, linux-sgx@vger.kernel.org,
        x86@kernel.org
Cc:     jarkko@kernel.org, reinette.chatre@intel.com,
        dave.hansen@intel.com, ashok.raj@intel.com, cathy.zhang@intel.com,
        chao.p.peng@linux.intel.com, yang.zhong@intel.com
Subject: Re: [PATCH v5 0/9] Support microcode updates affecting SGX
In-Reply-To: <20220520103904.1216-1-cathy.zhang@intel.com>
References: <20220520103904.1216-1-cathy.zhang@intel.com>
Date:   Tue, 24 May 2022 21:15:00 +0200
Message-ID: <87r14izqrv.ffs@tglx>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

Cathy,

On Fri, May 20 2022 at 18:38, Cathy Zhang wrote:
> First, the cadence of microcode updates has increased to deliver
> security mitigations. Second, the value of those updates has increased,
> meaning that any delay in applying them is unacceptable. Third, users
> have become accustomed to approaches like hot patching their kernels
> and have a growing aversion to reboots in general.
>
> Users want microcode updates to behave more like a hot patching a
> kernel and less like a BIOS update.

please don't take this personaly.

What users want and what's technically correct are two different things.

Fact is that late microcode updates especially those which change
features, add/remove functionality are simply broken. This has been
discussed to death already and I'm not going to find all the various
threads which provided that information. lore.kernel.org has excellent
search capabilities.

As a summary, there is a long standing request that for late loading
microcode needs to come with machine readable information about the
nature of the update which tells the kernel whether there are changes
which cannot be applied post boot.

This was agreed on by Intel folks and until this materializes any
attempt to load microcode late has to be considered as unsupported. This
is going on for years now and has been ignored.

As a consequence we are not adding a special SGX workaround for
something which is known to be broken.

What we are going to do and I'm fasttracking this is:

 https://lore.kernel.org/all/20220524185324.28395-1-bp@alien8.de

which make the SGX workaround moot.

Thanks

        tglx
