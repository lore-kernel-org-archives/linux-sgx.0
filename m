Return-Path: <SRS0=hhxz=6W=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1,
	USER_IN_DEF_DKIM_WL autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A6C48C4724C
	for <linux-sgx@archiver.kernel.org>; Fri,  8 May 2020 16:16:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7ACB7206B9
	for <linux-sgx@archiver.kernel.org>; Fri,  8 May 2020 16:16:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="a2oF2gMs"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728469AbgEHQQ2 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 8 May 2020 12:16:28 -0400
Received: from linux.microsoft.com ([13.77.154.182]:53532 "EHLO
        linux.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728568AbgEHQQX (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Fri, 8 May 2020 12:16:23 -0400
Received: from [192.168.1.17] (unknown [76.104.235.235])
        by linux.microsoft.com (Postfix) with ESMTPSA id 44FBD20B717B;
        Fri,  8 May 2020 09:16:21 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 44FBD20B717B
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1588954582;
        bh=zN67uqgpQYPNIbXXPTElpBVedXzm8/J7FKeWL5LhcC0=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=a2oF2gMsa+ICuVc/fFX8c0bRG5sTFQV0lrP2W7qsArF55ZaVGn5XMr/pThueCNHbj
         uT96kdEZc0eh2ics2DZm0dXWKu6UGV1F9ivnSvk398WUneD5yx+7ke+Ft7d7l59NSm
         u6bTcahIJckCuKo27xWXNu3LbEvuRzzP3VxXsz5o=
Subject: Re: [PATCH v29 00/20] Intel SGX foundations
To:     "Dr. Greg" <greg@enjellic.com>
Cc:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        linux-kernel@vger.kernel.org, x86@kernel.org,
        linux-sgx@vger.kernel.org, akpm@linux-foundation.org,
        dave.hansen@intel.com, sean.j.christopherson@intel.com,
        nhorman@redhat.com, npmccallum@redhat.com, haitao.huang@intel.com,
        andriy.shevchenko@linux.intel.com, tglx@linutronix.de,
        kai.svahn@intel.com, bp@alien8.de, josh@joshtriplett.org,
        luto@kernel.org, kai.huang@intel.com, rientjes@google.com,
        cedric.xing@intel.com, puiterwijk@redhat.com
References: <20200421215316.56503-1-jarkko.sakkinen@linux.intel.com>
 <e50f4c00-12e6-19e6-ead3-f180074bceea@linux.microsoft.com>
 <20200507180654.GA17632@wind.enjellic.com>
From:   Jordan Hand <jorhand@linux.microsoft.com>
Message-ID: <97a7a73b-53ea-d4f8-5323-f9f109150480@linux.microsoft.com>
Date:   Fri, 8 May 2020 09:16:20 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200507180654.GA17632@wind.enjellic.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On 5/7/20 11:06 AM, Dr. Greg wrote:
> On Wed, May 06, 2020 at 09:39:55AM -0700, Jordan Hand wrote:
> 
> Good afternoon, I hope the week is going well for everyone.
> 
>> On 4/21/20 2:52 PM, Jarkko Sakkinen wrote:
>>> Make the vDSO callable directly from C by preserving RBX and taking leaf
>>>    from RCX.
> 
>> Tested with the Open Enclave SDK on top of Intel PSW. Specifically built
>> the Intel PSW with changes to support /dev/sgx mapping[1] new in v29.
>>
>> Tested-by: Jordan Hand <jorhand@linux.microsoft.com>
>>
>> [1] https://github.com/intel/linux-sgx/pull/530
> 
> Did you re-wire your SDK to convert all your ECALL and exception
> handling to the new VDSO architecture?
 >

No. We have many users of our SDK who rely on the out-of-tree driver and 
will for the foreseeable future. I aim to support both in-tree and 
out-of-tree with minimal code diff.

>
> Failures in enclave loading and initialization demonstrate themselves
> pretty clearly and are in the domain of the PSW being used.  If there
> are going to be subtle SGX application operability issues that need to
> be found they will be in the new ECALL and exception handling
> mechanisms.

Fair enough, no I have not tested those mechanisms. Apologies, I should 
have removed that line from the quoted text.

-Jordan
