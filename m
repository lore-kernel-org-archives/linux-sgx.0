Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 02C6FC28D13
	for <linux-sgx@archiver.kernel.org>; Thu, 25 Aug 2022 04:42:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231177AbiHYEm2 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 25 Aug 2022 00:42:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232090AbiHYEm1 (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Thu, 25 Aug 2022 00:42:27 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01CBB9DFB0
        for <linux-sgx@vger.kernel.org>; Wed, 24 Aug 2022 21:42:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 72E13617C7
        for <linux-sgx@vger.kernel.org>; Thu, 25 Aug 2022 04:42:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D738C433C1;
        Thu, 25 Aug 2022 04:42:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661402545;
        bh=sjb8Lo+TVLJIsumgkrf44mBW9fDF9lAUAHejshAzsZI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=HPs66ovLJZH25QKC0tosPT2n721RS+09bAte3K8iCv6L+hgyqfCxLC8NO/lnKJEKB
         /TIfYsT8/vVancoUuSrkBHIdIgXfFcrQIVEvpcIRtCgSoaVGdbPNe2mc2E/5uz5Ytc
         Z1L22IWmT4PoDAu58okrzkC32dNxpRiaUhg7K1UtGrbUgQvpwRb7As8v5vKIG8Yj/B
         G+mub6LeDx1M/WHhcpmlElcWMkIiV5yz6g6/uxWkqXCSi+/q7UYrkbwOIDq+4JrGzD
         4213BkB+6WALKw9/vpE812QEI1O4XX7MPvs+fDrn9fD31myA1KoFFwYiL12ozRtxBo
         NiXSD0dHjiuQA==
Date:   Thu, 25 Aug 2022 07:42:18 +0300
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Dave Hansen <dave.hansen@intel.com>
Cc:     Haitao Huang <haitao.huang@linux.intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        linux-sgx@vger.kernel.org, reinette.chatre@intel.com,
        Borislav Petkov <bp@alien8.de>, Tony Luck <tony.luck@intel.com>
Subject: Re: [PATCH] selftests/sgx: retry the ioctls returned with EAGAIN
Message-ID: <Ywb9qg9Ij+VCaG5v@kernel.org>
References: <YvlPYRvMicz9CPFQ@kernel.org>
 <20220816051656.3622-1-haitao.huang@linux.intel.com>
 <Yvuok/Xd7+/kcUiR@kernel.org>
 <86165137-fbbf-6747-cd55-7e807aab9a6c@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86165137-fbbf-6747-cd55-7e807aab9a6c@intel.com>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Mon, Aug 22, 2022 at 04:24:50PM -0700, Dave Hansen wrote:
> On 8/16/22 07:24, Jarkko Sakkinen wrote:
> > Dave, in addition to [*], these should be picked x86 tree for v6.0
> > 
> > https://lore.kernel.org/linux-sgx/20220815233900.11225-1-jarkko@kernel.org/T/#t
> 
> Was there an ack somewhere in that thread that I missed?

Yes, both had mine.

I sent both unmodified bundled into a single patch set, except cosmetic
changes to the commit message. The discussion that followed up came up a
day later I've send that response.

The next version will be lacking ack's, given that I'm modifying the
patches, i.e. will be disqualified to review them.

BR, Jarkko
