Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5FE7C4361B
	for <linux-sgx@archiver.kernel.org>; Tue, 15 Dec 2020 15:59:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9CFAF224F4
	for <linux-sgx@archiver.kernel.org>; Tue, 15 Dec 2020 15:59:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730554AbgLOP7V (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 15 Dec 2020 10:59:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:42718 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730358AbgLOP7N (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Tue, 15 Dec 2020 10:59:13 -0500
Date:   Tue, 15 Dec 2020 17:58:24 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608047912;
        bh=tAjNgpJY4PkAjhuu5UfgtKhkfiF5jynWaqKRdXT8BPE=;
        h=From:To:Cc:Subject:References:In-Reply-To:From;
        b=mqa8WmM/tsEzWHx8onwjz99VZnQDaxYwqJnFunMBlxgS5WpP2+tpsX2bgwsmUOfwd
         WhbNHGoY65HC3uoEJA5HqDB5/1AHwMJMoedpy/kvan2xHgHUaBsk5L0YS1lx7UBEMD
         p9wTN0akouI1Tu7V8iIFGe2DJHNfJZGb2FWbYQqcf7kZTjaB9Aciv9aTrTcuO26ViG
         c/pLTvfa99f8WyYtGJFEAPNUkQ1gvH9xO+Flqfk0aZ5Ng/Gt7lTPsL0VgTC+u9NIJN
         68kDrv2svpZv7nyYeuMWSVEWnOT1BbEpiSsBWQfBz7aNQh3GJ4CSfoj3nYn198psc2
         WO8cuX391aaBQ==
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     "Hui, Chunyang" <sanqian.hcy@antgroup.com>
Cc:     x86@kernel.org, linux-sgx@vger.kernel.org,
        linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        andriy.shevchenko@linux.intel.com, asapek@google.com, bp@alien8.de,
        cedric.xing@intel.com, chenalexchen@google.com,
        conradparker@google.com, cyhanish@google.com,
        dave.hansen@intel.com, haitao.huang@intel.com, kai.huang@intel.com,
        kai.svahn@intel.com, kmoy@google.com, ludloff@google.com,
        luto@kernel.org, nhorman@redhat.com, npmccallum@redhat.com,
        puiterwijk@redhat.com, rientjes@google.com, tglx@linutronix.de,
        yaozhangx@google.com, mikko.ylinen@intel.com
Subject: Re: [PATCH v41 00/24] Intel SGX foundations
Message-ID: <20201215155824.GA34260@kernel.org>
References: <20201112220135.165028-1-jarkko@kernel.org>
 <20201215054313.GA522982@sanqian-occlum-dev-ubuntu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201215054313.GA522982@sanqian-occlum-dev-ubuntu>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Tue, Dec 15, 2020 at 01:43:22PM +0800, Hui, Chunyang wrote:
> Tested-by: Chunyang Hui <sanqian.hcy@antfin.com>
> 
> The Occlum project (https://occlum.io/) is a libOS built on top of Intel
> SGX feature. We ran Occlum tests using v5.10 kernel with SGX patch v41 on
> SGX hardware with the Flexible Launch Control (FLC) feature and didn't
> find any problems. As Occlum core developers, we would like these patches
> to be merged.

The patches and some fixes on top of them were pulled on Monday into
mainline tree. I advice you to test v5.11-rc's when they become
available and report any issues you might encounter.

/Jarkko
