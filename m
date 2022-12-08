Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC6D5C63703
	for <linux-sgx@archiver.kernel.org>; Thu,  8 Dec 2022 15:18:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230183AbiLHPSg (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 8 Dec 2022 10:18:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230204AbiLHPSP (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Thu, 8 Dec 2022 10:18:15 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BA3BA56DE;
        Thu,  8 Dec 2022 07:16:05 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5D776B823DC;
        Thu,  8 Dec 2022 15:15:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1264C433C1;
        Thu,  8 Dec 2022 15:15:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670512542;
        bh=DmWyuGFqzQqP+2VEv1enz/dMYLRgm6/Oc/LH1ZFoggQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=VCYZvUnvtyjVfPcc+ChgcW1bd1sv/15NbCHzwvHQOqXxuTWkY89fFu2u9LM87CIJ3
         HEb6QI7BOB8HeMztr3vhYFSo81m6rfJ9myzn0R54+6wOXybHgFUnpQsQashrexNKz7
         JhVoc+aWkiiNhDhP5AhABwYZIrbrzOCtWtL1+ZrDqEBrmww2KsuJvlRDpEyQ9QfBZE
         /6IrsrvXsd5zH4P3Z2bCLO1RQNFJTgAEVnM9NNc/Q465UAkIZKHJrdBCX+gBhWTQjJ
         xOH5JtucJDiGjMygTWjSaRAzY3bP0Q7n0OAKwcvw7gwmmtgjg3Qe2hmvQFYp9j0KBB
         v1JHnMMA/2rig==
Date:   Thu, 8 Dec 2022 15:15:37 +0000
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Kristen Carlson Accardi <kristen@linux.intel.com>
Cc:     dave.hansen@linux.intel.com, tj@kernel.org,
        linux-kernel@vger.kernel.org, linux-sgx@vger.kernel.org,
        cgroups@vger.kernel.org, Zefan Li <lizefan.x@bytedance.com>,
        Johannes Weiner <hannes@cmpxchg.org>, zhiquan1.li@intel.com
Subject: Re: [PATCH v2 15/18] cgroup/misc: Add per resource callbacks for css
 events
Message-ID: <Y5H/mY17TsQwSx9g@kernel.org>
References: <20221202183655.3767674-1-kristen@linux.intel.com>
 <20221202183655.3767674-16-kristen@linux.intel.com>
 <Y5H6ZLz7HXSaTF30@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y5H6ZLz7HXSaTF30@kernel.org>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Thu, Dec 08, 2022 at 02:53:24PM +0000, Jarkko Sakkinen wrote:
> On Fri, Dec 02, 2022 at 10:36:51AM -0800, Kristen Carlson Accardi wrote:
> > Consumers of the misc cgroup controller might need to perform separate actions
> > in the event of a cgroup alloc, free or release call. In addition,
> > writes to the max value may also need separate action. Add the ability
> > to allow downstream users to setup callbacks for these operations, and
> > call the per resource type callback when appropriate.
> > 
> > This code will be utilized by the SGX driver in a future patch.
> > 
> > Signed-off-by: Kristen Carlson Accardi <kristen@linux.intel.com>
> 
> I don't know what css is.

Now I know but it should be described in the commit message, i.e.
what the css is abbrevation of, and what does it mean in practice.

BR, Jarkko
