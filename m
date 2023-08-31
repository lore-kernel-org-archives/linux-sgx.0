Return-Path: <linux-sgx-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB48EC83F10
	for <linux-sgx@archiver.kernel.org>; Thu, 31 Aug 2023 08:25:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232666AbjHaIZ4 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 31 Aug 2023 04:25:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229705AbjHaIZz (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Thu, 31 Aug 2023 04:25:55 -0400
Received: from icts-p-cavuit-3.kulnet.kuleuven.be (icts-p-cavuit-3.kulnet.kuleuven.be [IPv6:2a02:2c40:0:c0::25:133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CADB0EE;
        Thu, 31 Aug 2023 01:25:51 -0700 (PDT)
X-KULeuven-Envelope-From: jo.vanbulck@cs.kuleuven.be
X-KULeuven-Scanned: Found to be clean
X-KULeuven-ID: 8E450201B9.AF3A3
X-KULeuven-Information: Katholieke Universiteit Leuven
Received: from icts-p-ceifnet-smtps-1.kuleuven.be (icts-p-ceifnet-smtps.service.icts.svcd [IPv6:2a02:2c40:0:51:132:242:ac11:16])
        by icts-p-cavuit-3.kulnet.kuleuven.be (Postfix) with ESMTP id 8E450201B9;
        Thu, 31 Aug 2023 10:25:49 +0200 (CEST)
BCmilterd-Mark-Subject: no
BCmilterd-Errors: 
BCmilterd-Report: SA-HVU#DKIM_VALID#0.00,SA-HVU#DKIM_SIGNED#0.00,SA-HVU#DKIM_VALID_AU#0.00
X-CAV-Cluster: smtps
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=cs.kuleuven.be;
        s=cav; t=1693470349;
        bh=eVUwZlVucS2YDCP+9RxOHN7cdg751vkhqvTHHj3aWIE=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To;
        b=GpN+8H7LbI9sWDjzTrljDhH9wt38tuQBMUkTm4kOazyP6pRAQzZKCC2VUGoCT9EHV
         HWAfutdcH3gYMPdvVYB07lN7Wcmryxzj2PPzAnrmLzuM5VGWCO3Ugl/BxKEWLJENBa
         fH1CxRPzwcNBWOO+5G6ZKFh6kEhI8HsXdJDuhzZ4=
Received: from [IPV6:2a02:1811:d31:8b00:7de6:eac8:3ad6:e6b8] (ptr-82s0fs7jt2487ph2gu0.18120a2.ip6.access.telenet.be [IPv6:2a02:1811:d31:8b00:7de6:eac8:3ad6:e6b8])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by icts-p-ceifnet-smtps-1.kuleuven.be (Postfix) with ESMTPSA id 4F6E5D4F7F196;
        Thu, 31 Aug 2023 10:25:49 +0200 (CEST)
Message-ID: <2c51779f-3a70-80e8-6b64-501b3d496484@cs.kuleuven.be>
Date:   Thu, 31 Aug 2023 10:25:52 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH v4 12/13] selftests/sgx: Remove redundant enclave base
 address save/restore
Content-Language: en-US
To:     "Huang, Kai" <kai.huang@intel.com>,
        "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        "jarkko@kernel.org" <jarkko@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc:     "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>
References: <20230825133252.9056-1-jo.vanbulck@cs.kuleuven.be>
 <20230825133252.9056-13-jo.vanbulck@cs.kuleuven.be>
 <54cc090bad89351862fa67c97d681e411336e2be.camel@intel.com>
X-Kuleuven: This mail passed the K.U.Leuven mailcluster
From:   Jo Van Bulck <jo.vanbulck@cs.kuleuven.be>
In-Reply-To: <54cc090bad89351862fa67c97d681e411336e2be.camel@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On 29.08.23 13:00, Huang, Kai wrote:
> ... please move this patch before patch 2?
> 
> Otherwise, strictly speaking patch 2 isn't complete, because after you apply
> patch 2 you still have this code which is obviously wrong -- %rbx is no longer
> enclave base address (although it never was even in the current upstream code).

Okay, moving this ahead.

Best,
Jo
