Return-Path: <SRS0=PKbn=UR=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D6591C31E5B
	for <linux-sgx@archiver.kernel.org>; Tue, 18 Jun 2019 15:13:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id ACC5921479
	for <linux-sgx@archiver.kernel.org>; Tue, 18 Jun 2019 15:13:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=tycho.nsa.gov header.i=@tycho.nsa.gov header.b="PqjbJpb9"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729720AbfFRPNt (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 18 Jun 2019 11:13:49 -0400
Received: from ucol19pa10.eemsg.mail.mil ([214.24.24.83]:53673 "EHLO
        UCOL19PA10.eemsg.mail.mil" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729684AbfFRPNs (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Tue, 18 Jun 2019 11:13:48 -0400
X-EEMSG-check-017: 687607179|UCOL19PA10_EEMSG_MP8.csd.disa.mil
X-IronPort-AV: E=Sophos;i="5.63,389,1557187200"; 
   d="scan'208";a="687607179"
Received: from emsm-gh1-uea10.ncsc.mil ([214.29.60.2])
  by UCOL19PA10.eemsg.mail.mil with ESMTP/TLS/DHE-RSA-AES256-SHA256; 18 Jun 2019 15:13:47 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=tycho.nsa.gov; i=@tycho.nsa.gov; q=dns/txt;
  s=tycho.nsa.gov; t=1560870827; x=1592406827;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=UdmPCuKVKLilSgz3CeEDYTIpJc+88O8Yjmi4YH4f9Dk=;
  b=PqjbJpb9SRtaBVwe+4wVYosh4VGsrzxDKLjO2XcF6Q2vIw0iZFO0hZRB
   JUQxcYRDNfcvFOWQpCQJW8DrVNnKnJ0dSpQwwOSiFJLGehYlt6bKlRQHa
   TFqin31+OIELl0SfKl5B8TdhGw+GNLmENiGT64N/HftUnmdqSM3tHQdPt
   IYtHJkXt1mPlihfwZrIOhQjf87nAt+7GibHg6jBezUN1zVp2k0di0NjFP
   AGVFlWCe7W0hXOUQ42Oi3yvsXDvANnL1VJsN13CQTm0rN63gqrkInWDXh
   O8EV7VQ8iAJHDuUUi1r5xVbvS4zOCALNzOSK45QIaE90pyQadeF/NF/N0
   g==;
X-IronPort-AV: E=Sophos;i="5.63,389,1557187200"; 
   d="scan'208";a="24856799"
IronPort-PHdr: =?us-ascii?q?9a23=3AqvCwNBd0doTQNXTg87GHS0kPlGMj4u6mDksu8p?=
 =?us-ascii?q?Mizoh2WeGdxc25ZheN2/xhgRfzUJnB7Loc0qyK6vqmATRLvMrJ8ChbNsAVDl?=
 =?us-ascii?q?ld0YRetjdjKfbNMVf8Iv/uYn5yN+V5f3ghwUuGN1NIEt31fVzYry76xzcTHh?=
 =?us-ascii?q?LiKVg9fbytScbdgMutyu+95YDYbRlWizqhe7NyKwi9oRnMusUMjoZuN7g9xg?=
 =?us-ascii?q?HVrndUdOhbxWxlLk+Xkxrg+8u85pFu/zlNt/4768JMTaD2dLkkQLJFCzgrL3?=
 =?us-ascii?q?o779DxuxnZSguP6HocUmEInRdNHgPI8hL0UIrvvyXjruZy1zWUMsPwTbAvRD?=
 =?us-ascii?q?St9LxrRwPyiCcGLDE27mfagdFtga1BoRKhoxt/w5PIYIyQKfFzcL/Rcc8cSG?=
 =?us-ascii?q?FcRctaSTBPDZ2gYIsOF+oBPPhXr4/hp1sVsBCyARCgCP7zxjNUg3P726M10/?=
 =?us-ascii?q?4lEQrbwgIuGdwAu2nQoNnsOqofVeW5wa/VxjvBcvxWwy/w5pXWfBAvof+CXr?=
 =?us-ascii?q?x+fsTexkYtCwzLgU6dqZDnMj6PyugBr2aW4uhmWOmyi2AnsQZxoj23y8kxlo?=
 =?us-ascii?q?nGmJoVylDa+iV/3Y07ONi4R1R/Yd6gDpRRtzyROoxtQsw/WGFlozo6y70atp?=
 =?us-ascii?q?67eygG0pInxwXFZPCdfIiI5QzjWf+XLDxlinxlf7e/iAyz8Uim0uD8Wci00E?=
 =?us-ascii?q?pKripYidbArGwC1xvW6sWBV/Bz/V+h1C6S2w3c5exIO0A5mbfBJ5I/zbM8iI?=
 =?us-ascii?q?AfvVnFEyTrgkv5lrWWeV8h+uWw7uTnZajpqYGEOo9vjwH+LrwumsuiAeQkKg?=
 =?us-ascii?q?QOX3aU+eC71LD74U32Wq9KjvwrkqnCqpzaOcQaqbK5Aw9SyIoj7QqwDyy639?=
 =?us-ascii?q?gCmHkHLVZFdAqGj4jvJV7OPOj1Aeqwjlmjijtmx+3KMqf/DpjCMHTPiqrtca?=
 =?us-ascii?q?5460FGyQozyd5f54hTCrEEOP/zQVL+tMfDAx8lMw273+bnCNJn2oMYQmKAGL?=
 =?us-ascii?q?WVMKzVsV+W/u4vOfWDZJcJuDbhLPgo/+XugmEjll8bZ6Wp34EbZ2y4HvR8Ik?=
 =?us-ascii?q?WZembsgtAZEWcKoAU+VvfqiFqEUTNIZnayWb486S8/CI68EYjDQYWtiqSb3C?=
 =?us-ascii?q?inBp1WenxGCleUHHfqbYqEQfQMaCGVIsN7iTwLT7uhS4wg1RGoqgD6zaFqLu?=
 =?us-ascii?q?7V+i0eqJLi28J55+zVlREu6zN0C96R3H2KT2FxhmkIXSM53LhjoUxhzVeOya?=
 =?us-ascii?q?x4g/1eFdxO6PJFSxw6NZHTzuFhFdDyVRzOfs2TRFalXNqmGzcxQcw1w9MUZE?=
 =?us-ascii?q?Z9AdqihAjZ3yW2G78Vi6CLBJss/63BxXfxOdhyx2zG1KY7iVkmWdVANWu9i6?=
 =?us-ascii?q?5+8QjTG5DGk0GDm6m2cqQc2TbH9H2fwmqWoEFYTAlwXL3ZUn8Be0TWt9X56V?=
 =?us-ascii?q?/YQ76hCLQnNARBxNWDKqtMdt3mk1FGSO3/N9TZZmK7g32wCgqQxrOQcIrqfH?=
 =?us-ascii?q?0Q3CHACEgYlAAe5nWGOhYkBienvW3eCCZiFVX1Y0Pj6eN+sm+0TlcozwGWaE?=
 =?us-ascii?q?1sz7i19QAJhfycUfMT2akJuCkmqzVuAFayxdTWC9uPpgZ7YKpcZtY96k9d1W?=
 =?us-ascii?q?3Frwx9IoCgL6d6i14RaQR4oUzu2g5pBYVGk8glsncqzA5zKa2Eyl9OazSY3Z?=
 =?us-ascii?q?WjcoHQf1L/9RbnQK7M20rC186W970U7/Jw/07utQfvFAwp829myMVSy3uR/I?=
 =?us-ascii?q?7NCiITV478VgA88B0s9J/AZSxo3J/ZzX1hN+GPtzbG3984TL8+xg2IY8ZUMK?=
 =?us-ascii?q?TCEhT7VcIdGZ79e6QRh1G1Y0dcb6hp/6kuMpbjLqDX1Q=3D=3D?=
X-IPAS-Result: =?us-ascii?q?A2CNAgCk/ghd/wHyM5BmHAEBAQQBAQcEAQGBZYFnKmpRA?=
 =?us-ascii?q?TIohBaTSgaBECWJU5EMCQEBAQEBAQEBAScNAQIBAYRAAoJRIzgTAQMBAQEEA?=
 =?us-ascii?q?QEBAQMBAWwcDII6KQGCZgEBAQECASMVQRALGAICJgICVwYNCAEBgl8/AYF2B?=
 =?us-ascii?q?Q8PqWmBMYVHgx+BQAaBDCiLXhd4gQeBEScMgl8+gmEChGuCWASLWYI0hhyBK?=
 =?us-ascii?q?ZQOCYISghuELY0FBhuTMoQClEGRUiGBWCsIAhgIIQ87gmyFf4pvIwMwgQYBA?=
 =?us-ascii?q?Y8qAQE?=
Received: from tarius.tycho.ncsc.mil ([144.51.242.1])
  by EMSM-GH1-UEA10.NCSC.MIL with ESMTP; 18 Jun 2019 15:13:46 +0000
Received: from moss-pluto.infosec.tycho.ncsc.mil (moss-pluto [192.168.25.131])
        by tarius.tycho.ncsc.mil (8.14.4/8.14.4) with ESMTP id x5IFDjRm012652;
        Tue, 18 Jun 2019 11:13:45 -0400
Subject: Re: [RFC PATCH v3 00/12] security: x86/sgx: SGX vs. LSM, round 3
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        linux-sgx@vger.kernel.org, Dave Hansen <dave.hansen@intel.com>,
        Cedric Xing <cedric.xing@intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Jethro Beekman <jethro@fortanix.com>,
        "Dr . Greg Wettstein" <greg@enjellic.com>
References: <20190617222438.2080-1-sean.j.christopherson@intel.com>
 <05bcc1e2-0bd7-dcb9-02c3-969f4484a5fc@tycho.nsa.gov>
 <20190618135525.GA13781@linux.intel.com>
From:   Stephen Smalley <sds@tycho.nsa.gov>
Message-ID: <360733f9-7064-f32c-e45e-03c256e98a8e@tycho.nsa.gov>
Date:   Tue, 18 Jun 2019 11:13:45 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190618135525.GA13781@linux.intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On 6/18/19 9:55 AM, Sean Christopherson wrote:
> On Tue, Jun 18, 2019 at 09:38:19AM -0400, Stephen Smalley wrote:
>> On 6/17/19 6:24 PM, Sean Christopherson wrote:
>>> My original plan was for my next RFC to be an implementation of Andy's
>>> proposed "dynamic tracking" model.  I actually finished the tracking
>>> portion, but was completely flummoxed by the auditing[1].  Since Cedric's
>>> RFC is essentially a variation of the dynamic tracking model, it too has
>>> the same auditing complexities.  End result, I ended back at the "make
>>> userspace state its intentions" approach.
>>>
>>> Except for patch 12 (see below), the SGX changes have been fully tested,
>>> including updating the kernel's selftest as well as my own fork of (an old
>>> version of) Intel's SDK to use the new UAPI.  The LSM changes have been
>>> smoke tested, but I haven't actually configured AppArmor or SELinux to
>>> verify the permissions work as intended.
>>
>> Was dropping linux-security-module and selinux lists intentional for this
>> RFC? Not recommended.
> 
> Yes, my thought was to keep the noise to the sgx list until we at least
> agree on a direction for the SGX UAPI.  I am fully expecting that whatever
> LSM and SELinux patches we end up with will go through a lot more scrutiny
> when Jarkko sends them with his SGX series.
> 
> Anyways, would you like me to resend the series to Cc the aforementioned
> lists?

I guess it depends on how soon you plan to spin another version. If 
soon, then you can wait on the next round.  But I wouldn't wait until 
everything else is fully baked because the LSM discussion might chase 
out issues that require changes elsewhere.

> 
>> Is the entire series aside from patch 12 available in a public tree
>> somewhere?
> 
> I pushed tag 'sgx-lsm-v3' to https://github.com/sean-jc/linux.git.
> 
>> Ultimately we'll want additions to the selinux-testsuite that exercise each
>> of the new permissions, both a permission denied scenario and a permission
>> allowed scenario.

