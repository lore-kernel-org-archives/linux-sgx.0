Return-Path: <SRS0=I7Yp=4J=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1,USER_IN_DEF_DKIM_WL autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8857DC11D00
	for <linux-sgx@archiver.kernel.org>; Fri, 21 Feb 2020 00:11:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 56A6A208E4
	for <linux-sgx@archiver.kernel.org>; Fri, 21 Feb 2020 00:11:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="Gqbbv60b"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729387AbgBUALG (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 20 Feb 2020 19:11:06 -0500
Received: from linux.microsoft.com ([13.77.154.182]:43026 "EHLO
        linux.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729373AbgBUALF (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Thu, 20 Feb 2020 19:11:05 -0500
Received: from [10.131.86.135] (unknown [131.107.147.135])
        by linux.microsoft.com (Postfix) with ESMTPSA id BF7BB2007690;
        Thu, 20 Feb 2020 16:11:04 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com BF7BB2007690
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1582243864;
        bh=zorJuQNXMnYkPB8Xz0B94YjuA01qeWQy1dyOh6tP+f8=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=Gqbbv60bmqz+5F6mV/kCW3gQZGu3DycmYrYLu8NMF+ZHg4LfwU14I/TTaZKt2yHJK
         qvlueHIQyEPAkSW+rKdO9Uxo1MXtzS5rI8gxvOKqp0qt1eantpqZaiLAqKmy20yLRv
         mHenMROitS8e5qUS0mN4zJi8tgUR3TtD4JvjaDLk=
Subject: Re: [PATCH v26 10/22] x86/sgx: Linux Enclave Driver
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     linux-kernel@vger.kernel.org, x86@kernel.org,
        linux-sgx@vger.kernel.org, akpm@linux-foundation.org,
        dave.hansen@intel.com, nhorman@redhat.com, npmccallum@redhat.com,
        haitao.huang@intel.com, andriy.shevchenko@linux.intel.com,
        tglx@linutronix.de, kai.svahn@intel.com, bp@alien8.de,
        josh@joshtriplett.org, luto@kernel.org, kai.huang@intel.com,
        rientjes@google.com, cedric.xing@intel.com, puiterwijk@redhat.com,
        linux-security-module@vger.kernel.org,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Haitao Huang <haitao.huang@linux.intel.com>
References: <20200209212609.7928-1-jarkko.sakkinen@linux.intel.com>
 <20200209212609.7928-11-jarkko.sakkinen@linux.intel.com>
 <15074c16-4832-456d-dd12-af8548e46d6d@linux.microsoft.com>
 <20200220181345.GD3972@linux.intel.com>
 <7738b3cf-fb32-5306-5740-59974444e327@linux.microsoft.com>
 <20200220184842.GE3972@linux.intel.com>
 <20200220221607.GB26618@linux.intel.com>
From:   Jordan Hand <jorhand@linux.microsoft.com>
Message-ID: <2c077197-a8a7-feac-58ea-e901c92fb58b@linux.microsoft.com>
Date:   Thu, 20 Feb 2020 16:11:04 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200220221607.GB26618@linux.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On 2/20/20 2:16 PM, Jarkko Sakkinen wrote:
> On Thu, Feb 20, 2020 at 10:48:42AM -0800, Sean Christopherson wrote:
>> My biggest concern for allowing PROT_EXEC if RIE is that it would result
>> in #PF(SGX) (#GP on Skylake) due to an EPCM violation if the enclave
>> actually tried to execute from such a page.  This isn't a problem for the
>> kernel as the fault will be reported cleanly through the vDSO (or get
>> delivered as a SIGSEGV if the enclave isn't entered through the vDSO), but
>> it's a bit weird for userspace as userspace will see the #PF(SGX) and
>> likely assume the EPC was lost, e.g. silently restart the enclave instead
>> of logging an error that the enclave is broken.
> 
> I think right way to fix the current implementation is to -EACCES mmap()
> (and mprotect) when !!(current->personality & READ_IMPLIES_EXEC).
> 

I agree. It still means userspace code with an executable stack can't
mmap/mprotect enclave pages and request PROT_READ but the check you've
proposed would more consistently enforce this which is easier to
understand from userspace perspective.

-Jordan
