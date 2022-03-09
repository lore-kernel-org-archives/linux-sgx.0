Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25C2BC433EF
	for <linux-sgx@archiver.kernel.org>; Wed,  9 Mar 2022 19:52:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235707AbiCITxf (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 9 Mar 2022 14:53:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231394AbiCITxe (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Wed, 9 Mar 2022 14:53:34 -0500
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A142E3B0
        for <linux-sgx@vger.kernel.org>; Wed,  9 Mar 2022 11:52:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646855553; x=1678391553;
  h=message-id:date:mime-version:to:cc:references:from:
   subject:in-reply-to:content-transfer-encoding;
  bh=VkMbO113qZqQLHlrIfqfFR752g7k213JlOsm9YKCn/I=;
  b=iaKhYrHA3ldRpuX21MxyVSxcQWeOBdSTu2N8Lkf8tc1XzrgDSMrQTan+
   afwirSxtGoiOKprh8K2L2KpWf7t0ywn4QkYncY80AD7TPsf9NUhD19gK1
   i9nsFNrXlCuIJefpmTbgsl3DddvsF9aN9dEppeIl6VBtQCmymhN/LFHdW
   CYZeFcKrcaf0qdcczaIMacm8txqgLD2Jb2uBXTMQbzdmkHviJtsmhP0bh
   mVlj0x5UDugheJbXYq2TJosZfhnPtVkrHwK7e1Ya0qKqjynwztmink/8b
   cTxE0k8QpUGyEiDrUbwCg4PGQ0j/QmMD3wSWrpjPhOEpHWDczS6KcRj1o
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10281"; a="255019128"
X-IronPort-AV: E=Sophos;i="5.90,168,1643702400"; 
   d="scan'208";a="255019128"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Mar 2022 11:52:33 -0800
X-IronPort-AV: E=Sophos;i="5.90,168,1643702400"; 
   d="scan'208";a="642279020"
Received: from sli6-mobl.amr.corp.intel.com (HELO [10.209.104.236]) ([10.209.104.236])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Mar 2022 11:52:32 -0800
Message-ID: <26cbb03e-dd9e-2f1d-0454-7e9b00b0927e@intel.com>
Date:   Wed, 9 Mar 2022 11:52:26 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Content-Language: en-US
To:     Borislav Petkov <bp@alien8.de>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Cathy Zhang <cathy.zhang@intel.com>, linux-sgx@vger.kernel.org,
        x86@kernel.org, "Raj, Ashok" <ashok.raj@intel.com>
References: <20220309104050.18207-1-cathy.zhang@intel.com>
 <87v8wnhrvg.ffs@tglx> <1742be9e-c18e-28c9-75c8-144bf1f6a311@intel.com>
 <YikBvBNwpWqDxKQl@zn.tnic>
From:   Dave Hansen <dave.hansen@intel.com>
Subject: Re: [RFC PATCH 00/11] Support microcode updates affecting SGX
In-Reply-To: <YikBvBNwpWqDxKQl@zn.tnic>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On 3/9/22 11:36, Borislav Petkov wrote:
> On Wed, Mar 09, 2022 at 11:14:22AM -0800, Dave Hansen wrote:
>> Let's imagine an extreme (thankfully imaginary) case: SGX has been
>> totally broken by some attack.  All running enclaves might have been
>> compromised.  A magical microcode update comes and saves the day and
>> mitigates the attack.
>>
>> From the hardware perspective, at the time of the microcode update, the
>> (presumably compromised) enclaves *can* still run.
> Here's where you lost me: the enclaves are presumably compromised and
> yet you wanna leave them running?! Isn't the strategy to kill them to
> limit the spread of whatever has compromised them?

Killing them immediately is a totally valid policy.  But, I think it's
also a valid policy to continue to let them run.  Maybe you know they
were not vulnerable to whatever got mitigated.  Or, maybe they're
sufficiently sandboxed that they are not of any concern.  You want new
enclaves to be able to attest to the new microcode, but you're just not
that worried about the old ones.

This mechanism allows userspace to separate the "update the microcode"
and "destroy the enclaves" and implement a policy which separates them
(or doesn't).

In either case, the specific demand from end users for this flexibility
is clearly lacking.  I'm sure Cathy and Ashok will get working to flesh
that out.
