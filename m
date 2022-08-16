Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27045C25B0E
	for <linux-sgx@archiver.kernel.org>; Tue, 16 Aug 2022 14:24:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234267AbiHPOY0 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 16 Aug 2022 10:24:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231453AbiHPOYY (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Tue, 16 Aug 2022 10:24:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E393940BE9
        for <linux-sgx@vger.kernel.org>; Tue, 16 Aug 2022 07:24:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 658B460FCA
        for <linux-sgx@vger.kernel.org>; Tue, 16 Aug 2022 14:24:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6882FC433C1;
        Tue, 16 Aug 2022 14:24:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660659862;
        bh=opT1Iq3EguL1dZo+chn84khIbel5Ylxe+7xol1qyj8M=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=BAoYrktJ5DMNgdbhrLjxKL43NzFezn/Km6N2Uy0STikkQBlCFPqz42SlcvvBRO3Y4
         aOdN57YzqqofJz5urfzBvuXIZ6eCndu+x51emLWu+Rnn/WCm9iFMOSBZa7o+hUWOgn
         y4S1mNa8tHpgQNj1d9S1Am+FsntpJSHsSxZ3Eh5NCxcEia9mSRSQBVR+unE4+urpib
         NQZrD5Sai4PhZcRTZugt3jUisbSyX1ku9AmRKAnd3EhQxfacTaeioWkFujQL9JyzuY
         Yss7dbAQ01Q/lLWmY1rX8OHg+zd7J2Z9p+GvwHII8Cc4ivMIs2jk9ksa8xz8FSzgQN
         ngaGlZhqf9j5g==
Date:   Tue, 16 Aug 2022 17:24:19 +0300
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Haitao Huang <haitao.huang@linux.intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>
Cc:     linux-sgx@vger.kernel.org, reinette.chatre@intel.com,
        Borislav Petkov <bp@alien8.de>, Tony Luck <tony.luck@intel.com>
Subject: Re: [PATCH] selftests/sgx: retry the ioctls returned with EAGAIN
Message-ID: <Yvuok/Xd7+/kcUiR@kernel.org>
References: <YvlPYRvMicz9CPFQ@kernel.org>
 <20220816051656.3622-1-haitao.huang@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220816051656.3622-1-haitao.huang@linux.intel.com>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Mon, Aug 15, 2022 at 10:16:56PM -0700, Haitao Huang wrote:
> For EMODT and EREMOVE ioctls with a large range, kernel
> may not finish in one shot and return EAGAIN error code
> and count of bytes of EPC pages on that operations are
> finished successfully.
> 
> Change the unclobbered_vdso_oversubscribed_remove test
> to rerun the ioctls in a loop, updating offset and length
> using the byte count returned in each iteration.
> 
> Signed-off-by: Haitao Huang <haitao.huang@linux.intel.com>
> Reviewed-by: Jarkko Sakkinen <jarkko@kernel.org>

Also,

Tested-by: Jarkko Sakkinen <jarkko@kernel.org>

Dave, in addition to [*], these should be picked x86 tree for v6.0

https://lore.kernel.org/linux-sgx/20220815233900.11225-1-jarkko@kernel.org/T/#t

BR, Jarkko
