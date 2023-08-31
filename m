Return-Path: <linux-sgx-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3CB40C83F10
	for <linux-sgx@archiver.kernel.org>; Thu, 31 Aug 2023 08:37:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235163AbjHaIh6 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 31 Aug 2023 04:37:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237237AbjHaIh6 (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Thu, 31 Aug 2023 04:37:58 -0400
Received: from icts-p-cavspool-1.kulnet.kuleuven.be (icts-p-cavspool-1.kulnet.kuleuven.be [IPv6:2a02:2c40:0:c0::25:194])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA74AE50;
        Thu, 31 Aug 2023 01:37:31 -0700 (PDT)
Received: from icts-p-cavuit-1.kulnet.kuleuven.be (icts-p-cavuit-1.kulnet.kuleuven.be [IPv6:2a02:2c40:0:c0::25:132])
        by icts-p-cavspool-1.kulnet.kuleuven.be (Postfix) with ESMTP id BDFB0285F;
        Thu, 31 Aug 2023 10:31:54 +0200 (CEST)
X-KULeuven-Envelope-From: jo.vanbulck@cs.kuleuven.be
X-KULeuven-Scanned: Found to be clean
X-KULeuven-ID: 1FB1F20164.AF4A1
X-KULeuven-Information: Katholieke Universiteit Leuven
Received: from icts-p-ceifnet-smtps-0.kuleuven.be (icts-p-ceifnet-smtps.service.icts.svcd [IPv6:2a02:2c40:0:51:139:242:ac11:1e])
        by icts-p-cavuit-1.kulnet.kuleuven.be (Postfix) with ESMTP id 1FB1F20164;
        Thu, 31 Aug 2023 10:31:33 +0200 (CEST)
BCmilterd-Mark-Subject: no
BCmilterd-Errors: 
BCmilterd-Report: SA-HVU#DKIM_VALID#0.00,SA-HVU#DKIM_VALID_AU#0.00,SA-HVU#DKIM_SIGNED#0.00
X-CAV-Cluster: smtps
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=cs.kuleuven.be;
        s=cav; t=1693470693;
        bh=p0kWUmhWcNvQ8nd2D5nXipqICNpi80pt1f4DYIhCgqw=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To;
        b=ggS+zZVVP4OanzuoWuArqyxRciv1wiOsywTh19v/WBSjq9zbgcLn07NTjQrEIsijD
         E9KczlabttvH2YbxW4W4bF0AvRTyAWsxEBGQdRcx9VW3DRTIosTl6fpgburqpemQeI
         7KB3rG1Vq7Hdh1niTDO8dQhbJxjzZtNQG1pm9bM8=
Received: from [IPV6:2a02:1811:d31:8b00:7de6:eac8:3ad6:e6b8] (ptr-82s0fs7jt2487ph2gu0.18120a2.ip6.access.telenet.be [IPv6:2a02:1811:d31:8b00:7de6:eac8:3ad6:e6b8])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by icts-p-ceifnet-smtps-0.kuleuven.be (Postfix) with ESMTPSA id D39F8D4F64519;
        Thu, 31 Aug 2023 10:31:32 +0200 (CEST)
Message-ID: <3ca535d3-0d68-85b2-724f-2b933f4f2d32@cs.kuleuven.be>
Date:   Thu, 31 Aug 2023 10:31:35 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH v4 05/13] selftests/sgx: Include memory clobber for inline
 asm in test enclave
Content-Language: en-US
To:     "Huang, Kai" <kai.huang@intel.com>,
        "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        "jarkko@kernel.org" <jarkko@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc:     "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>
References: <20230825133252.9056-1-jo.vanbulck@cs.kuleuven.be>
 <20230825133252.9056-6-jo.vanbulck@cs.kuleuven.be>
 <72d6a82f9069ffd209a47f7ba7817ac90b14593e.camel@intel.com>
X-Kuleuven: This mail passed the K.U.Leuven mailcluster
From:   Jo Van Bulck <jo.vanbulck@cs.kuleuven.be>
In-Reply-To: <72d6a82f9069ffd209a47f7ba7817ac90b14593e.camel@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On 29.08.23 13:07, Huang, Kai wrote:> To me this is also a bug fix 
patch, thus as Jarkko said should be ahead of other
> non-bug fix patches.
> 
> And also include the Fixes tag?

Thanks, moving this ahead and including the tag Fixes: 20404a808593 
("selftests/sgx: Add test for EPCM permission changes")

Best,
Jo
