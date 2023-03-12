Return-Path: <linux-sgx-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C4A3C74A44
	for <linux-sgx@archiver.kernel.org>; Sun, 12 Mar 2023 01:25:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229552AbjCLBZN (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Sat, 11 Mar 2023 20:25:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229437AbjCLBZM (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Sat, 11 Mar 2023 20:25:12 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDF2F5F6EE
        for <linux-sgx@vger.kernel.org>; Sat, 11 Mar 2023 17:25:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 27178B801BC
        for <linux-sgx@vger.kernel.org>; Sun, 12 Mar 2023 01:25:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CD53C433D2;
        Sun, 12 Mar 2023 01:25:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678584308;
        bh=TsZxqCa+KzoabxqFVUMnE9zFCL9qnixqjxXkjUAjwi8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=TZnNTyGBlDRrHd+kfc+ZJRi4mGD2rIION5rKAB4caHGs9Qvw4p6bS2/rni2ljxCej
         TmH5BZqR1oUWAs1XOf79pGHCtenG8NXOkqySL1R7ObRAkXi8B7ogAN2wUcD+mhkN0F
         A/Jdvlc2HtE/tP0JKmxPBJzMdyRaexRtfjDFUaMPYYGctotwvSHftc8Bvy7fOYhK21
         to8UKqSleUuJPFqewgM4YPAkV5bckR3ltaBFc193kfUvhWUbuc18HqHkdvlVbcNkOp
         8PBPwl+Ukel9vpBLXx9XMaUw46itvSfE/OK1ekF2QiLnW6w2+dd4rtHsspYpSIXM1T
         Of+HW5mK0/7pg==
Date:   Sun, 12 Mar 2023 03:25:05 +0200
From:   "jarkko@kernel.org" <jarkko@kernel.org>
To:     "Huang, Kai" <kai.huang@intel.com>
Cc:     "haitao.huang@linux.intel.com" <haitao.huang@linux.intel.com>,
        "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        "Chatre, Reinette" <reinette.chatre@intel.com>,
        "Dhanraj, Vijay" <vijay.dhanraj@intel.com>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>
Subject: Re: [RFC PATCH v4 2/4] x86/sgx: Implement support for MADV_WILLNEED
Message-ID: <ZA0p4Kf8sLcGBAJb@kernel.org>
References: <op.10dk8lsjwjvjmi@hhuan26-mobl.amr.corp.intel.com>
 <c37bb20995f234aa724724a06c96c76f18252e66.camel@intel.com>
 <op.10d2otjlwjvjmi@hhuan26-mobl.amr.corp.intel.com>
 <ef4087489625b0f8403c38e61348010dba62f623.camel@intel.com>
 <op.10ey84qywjvjmi@hhuan26-mobl.amr.corp.intel.com>
 <Y/AAbC/j04aUkd8R@kernel.org>
 <op.10i8zfw3wjvjmi@hhuan26-mobl.amr.corp.intel.com>
 <Y/VBOkmi7VbVuzAh@kernel.org>
 <op.10qusgctwjvjmi@hhuan26-mobl.amr.corp.intel.com>
 <5de607230294552829b075846a66688f65f3f74e.camel@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5de607230294552829b075846a66688f65f3f74e.camel@intel.com>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Tue, Mar 07, 2023 at 11:32:15PM +0000, Huang, Kai wrote:
> And in following mmap()s in which we want to map a small range of enclave:
> 
> 	encl_addr = mmap(encl_addr, MAP_SHARED|MAP_FIXED, encl_fd,
> 			(encl_addr - encl_base) >> PAGE_SHIFT);
> 
> ?
> 
> Anything wrong above?

I'm not sure I fully comprehended your response because it was
honestly a bit scattered so please correct me if I'm missing
something but: why a process would want to map a small range
of an enclave?

You anyway most likely want to enter to the enclave. Is this
for ptrace()?

BR, Jarkko
