Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE408C433F5
	for <linux-sgx@archiver.kernel.org>; Mon, 14 Mar 2022 03:43:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235356AbiCNDoh (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Sun, 13 Mar 2022 23:44:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231910AbiCNDog (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Sun, 13 Mar 2022 23:44:36 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A3EDFD19;
        Sun, 13 Mar 2022 20:43:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A7A5C60FA9;
        Mon, 14 Mar 2022 03:43:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8AAADC340F4;
        Mon, 14 Mar 2022 03:43:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647229407;
        bh=Rbkk61k7pLVhoia4oc1jOSpz6Ini/9QrIlxbsZvdqXM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=IH7fsJ/AfB8HKAP7zz2ZMjNVXu6fyD+gnA5DC+sdIdwG385SHHE5bNmvrAd5XRVy1
         YxOziEdzPNYTL5OqvUBaOmS8CjnB7utNWVbywOEwDghXWl1wb+EUE+OOwNFqwJcJcr
         UcCSAVx+GUH7a1s1jx1qs1ZsztweZ2XFFJJkXlya8MEhzEJS0/HUJjb1G7KjT+fy7e
         Lyo3VG65loS2RY6jKUsqsaB+qYvah/n3jYvI+bEmb4dOK4gWYJdL6qLtn7C+iqm2t9
         /mTQKbQLh53Aq4IoGkHjKt6Muxp0mmOr7thKuin2SlpvzWltAU2scj9qg2nlywGlei
         t7/5Bqn+K9H+g==
Date:   Mon, 14 Mar 2022 05:42:40 +0200
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Reinette Chatre <reinette.chatre@intel.com>
Cc:     Haitao Huang <haitao.huang@linux.intel.com>,
        "Dhanraj, Vijay" <vijay.dhanraj@intel.com>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "bp@alien8.de" <bp@alien8.de>,
        "Lutomirski, Andy" <luto@kernel.org>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "Huang, Kai" <kai.huang@intel.com>,
        "Zhang, Cathy" <cathy.zhang@intel.com>,
        "Xing, Cedric" <cedric.xing@intel.com>,
        "Huang, Haitao" <haitao.huang@intel.com>,
        "Shanahan, Mark" <mark.shanahan@intel.com>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH V2 16/32] x86/sgx: Support restricting of enclave page
 permissions
Message-ID: <Yi65sM+yCvZU0/am@iki.fi>
References: <4ce06608b5351f65f4e6bc6fc87c88a71215a2e7.1644274683.git.reinette.chatre@intel.com>
 <YhLhoMFPyOFZ2fsX@iki.fi>
 <DM8PR11MB55917F499CDF4CC7D426B0A7F63C9@DM8PR11MB5591.namprd11.prod.outlook.com>
 <YimWaAqEnXHbLdjh@iki.fi>
 <op.1itu5vkewjvjmi@hhuan26-mobl1.mshome.net>
 <Yis8LV99mORcLYs6@iki.fi>
 <Yis9rA8uC/0bmWCF@iki.fi>
 <97565fed-dc67-bab1-28d4-c40201c9f055@intel.com>
 <YiuQx+X9UQ2l22un@iki.fi>
 <e1c04077-0165-c5ec-53be-7fd732965e80@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e1c04077-0165-c5ec-53be-7fd732965e80@intel.com>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Fri, Mar 11, 2022 at 11:28:27AM -0800, Reinette Chatre wrote:
> Supporting permission restriction in an ioctl() enables the runtime to manage
> the enclave memory without needing to map it.

Which is opposite what you do in EAUG. You can also augment pages without
needing the map them. Sure you get that capability, but it is quite useless
in practice.

> I have considered the idea of supporting the permission restriction with
> mprotect() but as you can see in this response I did not find it to be
> practical.

Where is it practical? What is your application? How is it practical to
delegate the concurrency management of a split mprotect() to user space?
How do we get rid off a useless up-call to the host?

> Reinette

BR, Jarkko
