Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 64E68C433EF
	for <linux-sgx@archiver.kernel.org>; Wed,  9 Mar 2022 15:42:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231190AbiCIPn3 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 9 Mar 2022 10:43:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233930AbiCIPn1 (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Wed, 9 Mar 2022 10:43:27 -0500
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7675C3193D;
        Wed,  9 Mar 2022 07:42:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646840548; x=1678376548;
  h=message-id:date:mime-version:to:cc:references:from:
   subject:in-reply-to:content-transfer-encoding;
  bh=s7HKLTZRPh87Q7HE1OrSY5PA0akq2WRHHnFI9Y44ThQ=;
  b=h8z9Khq5N30hbySvkzucQlNVxWMn+Xhe5nX9+/H2afuZfOvA1a0+OUGg
   QkEtjcOV3TZWQbTjBvcDBE+oeqbZbLJhCo3IcLjFdvISqDk1zonIrScoL
   hwbiX2QMTGWoMbwkBlxKbLwJA2gjZENvngYYqeVvl2j+0A+uzumJihVt3
   4PLSFjOC+2UKBKXbKJe5Eyvc+oQQKOhytNyOBQ6cYSkZbxuJjPWYPXdHI
   apCIMsBe5Ta8CsWU1lLy/ZSfLdKK8Vsci6+2/QmAvYHwegZdcoAZgaUpz
   LJiquWatg6vV3VtFBNsTMmI6To1+hxf1nzrYar3ZjVelebykpzguX/bEb
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10281"; a="254732801"
X-IronPort-AV: E=Sophos;i="5.90,167,1643702400"; 
   d="scan'208";a="254732801"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Mar 2022 07:42:28 -0800
X-IronPort-AV: E=Sophos;i="5.90,167,1643702400"; 
   d="scan'208";a="642186649"
Received: from sli6-mobl.amr.corp.intel.com (HELO [10.209.104.236]) ([10.209.104.236])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Mar 2022 07:42:27 -0800
Message-ID: <35449b18-d77e-387b-f802-48f8013dfdf9@intel.com>
Date:   Wed, 9 Mar 2022 07:42:21 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Content-Language: en-US
To:     Borislav Petkov <bp@alien8.de>, Cathy Zhang <cathy.zhang@intel.com>
Cc:     linux-sgx@vger.kernel.org, x86@kernel.org,
        lkml <linux-kernel@vger.kernel.org>
References: <20220309104050.18207-1-cathy.zhang@intel.com>
 <20220309104050.18207-10-cathy.zhang@intel.com> <YiiNPWdsYtWiULZm@zn.tnic>
From:   Dave Hansen <dave.hansen@intel.com>
Subject: Re: [RFC PATCH 09/11] x86/microcode: Expose EUPDATESVN procedure via
 sysfs
In-Reply-To: <YiiNPWdsYtWiULZm@zn.tnic>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On 3/9/22 03:20, Borislav Petkov wrote:
> AFAICT, you want to hook into microcode_check() which runs after the
> microcode update and do your EUPDATESVN there...

There's a little bit in the cover letter that _implies_ why EUPDATESVN
isn't called during the actual microcode update:

> This series implements the infrastructure needed to track and tear
> down bare-metal enclaves and then run EUPDATESVN. This is expected
> to be triggered by administrators via sysfs at some convenient time
> after a microcode update, probably by the microcode update tooling
> itself.

This allows the (non-destructive) ucode update and the destructive
EUPDATESVN procedure to happen at different times.

If we just want to make the ucode update itself call EUPDATESVN via
microcode_check(), that makes the ucode update itself destructive to SGX
enclaves.  That's not the end of the world, but this series is going to
some amount of trouble (including new ABI) to avoid it.

Perhaps we need to hear more about why this is so much of an issue.
