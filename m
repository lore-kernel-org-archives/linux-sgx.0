Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 26BB0C433F5
	for <linux-sgx@archiver.kernel.org>; Thu, 17 Mar 2022 04:46:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229441AbiCQErQ (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 17 Mar 2022 00:47:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229448AbiCQErO (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Thu, 17 Mar 2022 00:47:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49CC4D0AB6;
        Wed, 16 Mar 2022 21:36:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9D2496159F;
        Thu, 17 Mar 2022 04:36:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F69BC340E9;
        Thu, 17 Mar 2022 04:36:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647491790;
        bh=Lue/McpKwZkA/DM4GAvGw2PEj41958MtazihdI9RSKY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=XcGoSgBtvNxteSNKGLlkG/NdC/0lG0vTGnG2fp5GSEuGY0TxHD7ZcslU0MGPzDskC
         K/WuHWrAleRVhPd0JljSVFei7/ckMJP7PQYJOJcAaWX9t7Rl4Hj3x3E1UTBJxmoXt1
         5xKs/LAzKFijaJ4CJGf3jpR0fW8aB/z3jFl2ihU+nayx66W2F8De0PllbP+mQi5DYr
         k2zAnDJ9u2CPNcKfXved+KZCpHb/wlf95wTbQMnAtP07os+a+rpVckO2SdxBPYuQ26
         GAYEZQ2RPATJS6hdVoByqKgd4nLOZZ6O3VA4cndXG+mCgYr58sJehHQCE2/uV0aHrI
         4OirvfaYnuhfg==
Date:   Thu, 17 Mar 2022 06:37:26 +0200
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Haitao Huang <haitao.huang@linux.intel.com>
Cc:     Reinette Chatre <reinette.chatre@intel.com>,
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
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        nathaniel@profian.com
Subject: Re: [PATCH V2 16/32] x86/sgx: Support restricting of enclave page
 permissions
Message-ID: <YjK7BppjPCio0xv7@iki.fi>
References: <DM8PR11MB55917F499CDF4CC7D426B0A7F63C9@DM8PR11MB5591.namprd11.prod.outlook.com>
 <YimWaAqEnXHbLdjh@iki.fi>
 <op.1itu5vkewjvjmi@hhuan26-mobl1.mshome.net>
 <Yis8LV99mORcLYs6@iki.fi>
 <Yis9rA8uC/0bmWCF@iki.fi>
 <97565fed-dc67-bab1-28d4-c40201c9f055@intel.com>
 <Yi6tPLLt9Q+ailQ3@iki.fi>
 <Yi6tinbF+Y7a66eQ@iki.fi>
 <Yi6va4dCaljiQ1WQ@iki.fi>
 <op.1i01q9s0wjvjmi@hhuan26-mobl1.mshome.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <op.1i01q9s0wjvjmi@hhuan26-mobl1.mshome.net>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Mon, Mar 14, 2022 at 10:39:36AM -0500, Haitao Huang wrote:
> I also see this model as consistent to what kernel does for regular memory
> mappings: adding physical pages on #PF or pre-fault and changing PTE
> permissions only after mprotect is called.

And you were against this in EAUG's case. As in the EAUG's case
EMODPR could be done as part of the mprotect() flow.

BR, Jarkko

