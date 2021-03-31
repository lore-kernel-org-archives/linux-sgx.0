Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 980DCC433ED
	for <linux-sgx@archiver.kernel.org>; Wed, 31 Mar 2021 23:23:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 618C161077
	for <linux-sgx@archiver.kernel.org>; Wed, 31 Mar 2021 23:23:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229515AbhCaXW4 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 31 Mar 2021 19:22:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:57250 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232271AbhCaXWX (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 31 Mar 2021 19:22:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 260D461003;
        Wed, 31 Mar 2021 23:22:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617232943;
        bh=69X5PvLuQdP9jyhccuiia1uzYNes/JBu6hLqsMw3Hxk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=XImULzsETxA4F2Umuvit8GCukaK2wGyML2LzwPuzh/VqMfH2waamalG7inwIYOzEd
         vrVXUno/bWZqBMiFZOemV2+3CITjjeHTxrleENCUGDpE/gzmoraCN2f4ybHxOPevkZ
         lJXCH7gyTy05pOJmqPC3AFselN78DPZ8tb/QMuN6hvGGgAo3nlRLRPpdBY6sbgGNRI
         wgEVIM6fLyMAB6lvNc/dciwi7y10R7VqCXciEkOS2hcRWsJ2B7Fx3NKCbwHG9W0bwE
         iW+mR4DeKtgJZJSbJNr0uXB8Y+KJEklM0laR6OwL3x23GpHVaO6Z7C1je0899vDz1E
         BpAVay1O/+cvw==
Date:   Thu, 1 Apr 2021 02:22:21 +0300
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Raoul Strackx <raoul.strackx@fortanix.com>
Cc:     linux-sgx@vger.kernel.org
Subject: Re: [PATCH 1/3] x86/sgx: Adding eextend ioctl
Message-ID: <YGUELcaqrETXiv3R@kernel.org>
References: <1b002a72-139d-0ed3-28ea-0d4980e110f3@fortanix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1b002a72-139d-0ed3-28ea-0d4980e110f3@fortanix.com>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Wed, Mar 31, 2021 at 02:18:50PM +0200, Raoul Strackx wrote:
> The current sgx driver can only launch enclaves that always measure 4K
> pages. That may not necessarily be the case. This patch adds an ioctl to
> enable users to add the enclave measurement per 256 byte.

Please run scripts/checkpatch.pl. You cannot write a long description in
a single line.

Also please write 'SGX' instead of 'sgx'.

I do understand the code change but also the current ioctl measure per 256
byte the full page. What I'm saying that the long description does not
contain any information what this patch adds to that. It neither makes the
case why it makes sense to have enclaves where full pages are not measured.

/Jarkko
