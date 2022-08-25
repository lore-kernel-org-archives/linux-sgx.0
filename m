Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 66681C04AA5
	for <linux-sgx@archiver.kernel.org>; Thu, 25 Aug 2022 05:39:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233942AbiHYFjV (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 25 Aug 2022 01:39:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230509AbiHYFjV (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Thu, 25 Aug 2022 01:39:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F6149F0E0
        for <linux-sgx@vger.kernel.org>; Wed, 24 Aug 2022 22:39:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3492361856
        for <linux-sgx@vger.kernel.org>; Thu, 25 Aug 2022 05:39:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 444BEC433C1;
        Thu, 25 Aug 2022 05:39:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661405959;
        bh=i9aIa9m5jQURozJZ9/sDcEb/qvmT/YLTIWgbirbBX5k=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=PTHORLVmgXUdgzXcZkk0H1feV4wYTvMWUIpwCR78eZ3QTQ69Jq5sXSRcN6yK09PmI
         g0Rv6SDtwUO7lpyn2qAbDFCucWZGD9PwSADx+8Lez/LiC4i3cuVTRjIxMGUHmyAJtg
         86djFWVxG5n34vmvU9QtcDPG/N6GukmbeptRT80tdVBAXsSU8Asyv7jzK123e/42uQ
         134n8oFWF0g4VALabLHzYKtJSAg/VRG5P3PsXodNtbvOZ5YpE3aER58xy3vtykiA7y
         QfZeVyb4nEQWrowK05RZC11qyPvpZ09GK9YF+KcUl9MNcoIRU4jsHqnykSTOcU8WRo
         cM0gIcTWt/mFA==
Date:   Thu, 25 Aug 2022 08:39:12 +0300
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Dave Hansen <dave.hansen@intel.com>
Cc:     Haitao Huang <haitao.huang@linux.intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        linux-sgx@vger.kernel.org, reinette.chatre@intel.com,
        Borislav Petkov <bp@alien8.de>, Tony Luck <tony.luck@intel.com>
Subject: Re: [PATCH] selftests/sgx: retry the ioctls returned with EAGAIN
Message-ID: <YwcLAMB0HGHUU4bx@kernel.org>
References: <YvlPYRvMicz9CPFQ@kernel.org>
 <20220816051656.3622-1-haitao.huang@linux.intel.com>
 <Yvuok/Xd7+/kcUiR@kernel.org>
 <86165137-fbbf-6747-cd55-7e807aab9a6c@intel.com>
 <Ywb9qg9Ij+VCaG5v@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Ywb9qg9Ij+VCaG5v@kernel.org>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Thu, Aug 25, 2022 at 07:42:18AM +0300, Jarkko Sakkinen wrote:
> On Mon, Aug 22, 2022 at 04:24:50PM -0700, Dave Hansen wrote:
> > On 8/16/22 07:24, Jarkko Sakkinen wrote:
> > > Dave, in addition to [*], these should be picked x86 tree for v6.0
> > > 
> > > https://lore.kernel.org/linux-sgx/20220815233900.11225-1-jarkko@kernel.org/T/#t
> > 
> > Was there an ack somewhere in that thread that I missed?
> 
> Yes, both had mine.
> 
> I sent both unmodified bundled into a single patch set, except cosmetic
> changes to the commit message. The discussion that followed up came up a
> day later I've send that response.
> 
> The next version will be lacking ack's, given that I'm modifying the
> patches, i.e. will be disqualified to review them.

Also, the next version will include additional patch for
a bpftrace script derived from what I tossed with Haitao
in order to root cause the error. Probably useful to have
available, as it did the trick.

BR, Jarkko
