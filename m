Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4FF04C47096
	for <linux-sgx@archiver.kernel.org>; Thu,  3 Jun 2021 06:57:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 380A1613DC
	for <linux-sgx@archiver.kernel.org>; Thu,  3 Jun 2021 06:57:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229794AbhFCG7c (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 3 Jun 2021 02:59:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:48226 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229665AbhFCG7c (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 3 Jun 2021 02:59:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1DC37613D8;
        Thu,  3 Jun 2021 06:57:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622703468;
        bh=I2Kux3S3a4pUYr512UBh1s5/0fSSQHlpWqVzey0Iw44=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=oiRRuxD659BwJF3d/PJgxz/RZkOtzVs0tB4VVgES0RFrEv+uYoFDH1XXLIk34R9fm
         Sxde7POUi6K3YbrBXNGDExA56wX5aYAVE+0KdkLICLZQ+fAmzQSsP862mBgxd7kFRr
         WY4hc9/aaBJoNo/AsRwEHIwAnaOVzWstetprwoahqSCK6IUngKEw2d2fQaAfC4z5CJ
         vQG0wm4WQGKGVPM70gSOWyZraVdU0NUE9LuAjDmiZQLlhJXk489KgGDcbAzPusw5nX
         P5p1TEbhMft1H0NExG/tRSMBgIh81OBTv3Whq/AaPSvnCqo2LQ9AY8hpP2kkP/W1lh
         2GjzAxAadncVA==
Date:   Thu, 3 Jun 2021 09:57:45 +0300
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Du Cheng <ducheng2@gmail.com>
Cc:     linux-sgx@vger.kernel.org, kai.huang@intel.com,
        dave.hansen@intel.com
Subject: Re: [BUG] bug report on x86/sgx: ksgxd()
Message-ID: <20210603065745.v3iupi3k3oxea424@kernel.org>
References: <YLb8y5YMFAsRKJMg@nuc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YLb8y5YMFAsRKJMg@nuc>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Wed, Jun 02, 2021 at 11:36:43AM +0800, Du Cheng wrote:
> Hi,
> 
> I like to report a bug on my linux box running the mainline linux of version:
> commit 8124c8a6b35386f73523d27eacb71b5364a68c4c tag: v5.13-rc4
> 
> After it boots on my intel NUC, I encounter this error in the console log, I
> believe it is triggered by a WARN_ON():
> 
> [    0.628094] sgx: EPC section 0x30200000-0x35f7ffff
> [    0.628503] ------------[ cut here ]------------
> [    0.628506] WARNING: CPU: 6 PID: 127 at arch/x86/kernel/cpu/sgx/main.c:428 ksgxd+0x1c8/0x1e0
> 
> 
> I have attached my config file with which I compiled the kernel, just in case it is helpful.
> 
> I am running on ubuntu 21.04 with mainline kernel, and my box is intel NUC:
> 
> 	Product Name: NUC10i5FNH
> 	SKU Number: BXNUC10i5FNH
> 	Product Name: NUC10i5FNB

Is it possible to test with 5.12?

Linux does not support that hardware, except for KVM VM's, which was
added in 5.13.

/Jarkko

/Jarkko
