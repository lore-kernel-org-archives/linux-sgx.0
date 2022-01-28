Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE087C433EF
	for <linux-sgx@archiver.kernel.org>; Fri, 28 Jan 2022 11:50:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348228AbiA1Luu (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 28 Jan 2022 06:50:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348220AbiA1Lus (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Fri, 28 Jan 2022 06:50:48 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F22FC061714
        for <linux-sgx@vger.kernel.org>; Fri, 28 Jan 2022 03:50:48 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 45CAC61984
        for <linux-sgx@vger.kernel.org>; Fri, 28 Jan 2022 11:50:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34968C340E0;
        Fri, 28 Jan 2022 11:50:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643370646;
        bh=m5snDYPVuymlVB9cJfCJz3kxb8y3dnu+Wu7QKuY289U=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=aJrs7dh9JRKV6YHuKcX0nBrL6S5F/Qtlr7EP4+sdBw5tuW4bHSvYejKcaQeacT/M9
         XL3McD5st3grgceNi/edIr5+k+ulkIgu/nI5OFukueLdi1qk/4tq48NVE9fHBcCcOK
         z80bcKXAhDpO9Oo9gKCFiDvZ6DCmbYrK9TUtsAjkrdfrcAu0+IGVIiJbCo7hwbW2nb
         Uo8snTbyPecOPUvWgGlopeURUGeZC08TQOdxn/V9clhlN5jFWgSwi99wHFdOborLX+
         ZcXClWy+uhlzbwL89Qjve1cS8elXb0nq5O4YY49VQ9WViKUql7N3Cjj33rw9qFSrO9
         /KsdtmR0CpewA==
Date:   Fri, 28 Jan 2022 13:50:22 +0200
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     linux-sgx@vger.kernel.org
Cc:     dave.hansen@linux.intel.com, kristen@linux.intel.com,
        cedric.xing@intel.com, haitao.huang@intel.com,
        reinette.chatre@intel.com, bp@alien8.de, seanjc@google.com,
        luto@kernel.org, nathaniel@profian.com, harald@profian.com
Subject: Re: aesmd availability
Message-ID: <YfPYfsnjYXQsY6Jz@iki.fi>
References: <YfPAh8m1c9LI6plB@iki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YfPAh8m1c9LI6plB@iki.fi>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Fri, Jan 28, 2022 at 12:08:07PM +0200, Jarkko Sakkinen wrote:
> I noticed that with aesmd the only feasible way to host it is to make a
> VM for it because:
> 
> - A beter predictable round-trip time for attestation.
> - In the worst case, attestation could be potentially blocked.
> 
> Should the driver have a page locking mechanism to make this more robust,
> or do we want to satisfy to this? I'm not 100% sure what'd be the right
> path forward, just pointing out a potential availability issue.

Probably makes sense to spread just a bit :-)

BR, Jarkko
