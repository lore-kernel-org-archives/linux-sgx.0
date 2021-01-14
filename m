Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1BB1C433E0
	for <linux-sgx@archiver.kernel.org>; Thu, 14 Jan 2021 18:36:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7CB7923B1F
	for <linux-sgx@archiver.kernel.org>; Thu, 14 Jan 2021 18:36:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728595AbhANSfs (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 14 Jan 2021 13:35:48 -0500
Received: from mga03.intel.com ([134.134.136.65]:60664 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727754AbhANSfr (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 14 Jan 2021 13:35:47 -0500
IronPort-SDR: W9D4okNR1QGKl8Ggzzls2eNiSoGqZiyTQNDVgk/E1Kqjxf5krW/J+ncX59/Gp08KnUuYUWvq9Q
 4JpbY/x2vQ1A==
X-IronPort-AV: E=McAfee;i="6000,8403,9864"; a="178510718"
X-IronPort-AV: E=Sophos;i="5.79,347,1602572400"; 
   d="scan'208";a="178510718"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jan 2021 10:35:05 -0800
IronPort-SDR: mqVhmo9it36IFx5chO8LGwy5lH2/4xEmYyMoivOxxsVJYj2aAY1WU26TTqSo6h6I/kCiDQSJO6
 sA0mcMaoLAFA==
X-IronPort-AV: E=Sophos;i="5.79,347,1602572400"; 
   d="scan'208";a="405244828"
Received: from jkrucker-mobl.amr.corp.intel.com (HELO [10.209.41.100]) ([10.209.41.100])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jan 2021 10:35:03 -0800
Subject: Re: [PATCH RFC] x86/sgx: Add trivial NUMA allocation
To:     Jarkko Sakkinen <jarkko@kernel.org>
Cc:     x86@kernel.org, linux-kernel@vger.kernel.org,
        linux-sgx@vger.kernel.org, Sean Christopherson <seanjc@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>, Jiri Kosina <trivial@kernel.org>
References: <20201216135031.21518-1-jarkko@kernel.org>
 <34b1acd1-e769-0dc2-a225-8ce3d2b6a085@intel.com>
 <YACFasdDi0siM2ML@kernel.org>
From:   Dave Hansen <dave.hansen@intel.com>
Autocrypt: addr=dave.hansen@intel.com; keydata=
 xsFNBE6HMP0BEADIMA3XYkQfF3dwHlj58Yjsc4E5y5G67cfbt8dvaUq2fx1lR0K9h1bOI6fC
 oAiUXvGAOxPDsB/P6UEOISPpLl5IuYsSwAeZGkdQ5g6m1xq7AlDJQZddhr/1DC/nMVa/2BoY
 2UnKuZuSBu7lgOE193+7Uks3416N2hTkyKUSNkduyoZ9F5twiBhxPJwPtn/wnch6n5RsoXsb
 ygOEDxLEsSk/7eyFycjE+btUtAWZtx+HseyaGfqkZK0Z9bT1lsaHecmB203xShwCPT49Blxz
 VOab8668QpaEOdLGhtvrVYVK7x4skyT3nGWcgDCl5/Vp3TWA4K+IofwvXzX2ON/Mj7aQwf5W
 iC+3nWC7q0uxKwwsddJ0Nu+dpA/UORQWa1NiAftEoSpk5+nUUi0WE+5DRm0H+TXKBWMGNCFn
 c6+EKg5zQaa8KqymHcOrSXNPmzJuXvDQ8uj2J8XuzCZfK4uy1+YdIr0yyEMI7mdh4KX50LO1
 pmowEqDh7dLShTOif/7UtQYrzYq9cPnjU2ZW4qd5Qz2joSGTG9eCXLz5PRe5SqHxv6ljk8mb
 ApNuY7bOXO/A7T2j5RwXIlcmssqIjBcxsRRoIbpCwWWGjkYjzYCjgsNFL6rt4OL11OUF37wL
 QcTl7fbCGv53KfKPdYD5hcbguLKi/aCccJK18ZwNjFhqr4MliQARAQABzShEYXZpZCBDaHJp
 c3RvcGhlciBIYW5zZW4gPGRhdmVAc3I3MS5uZXQ+wsF7BBMBAgAlAhsDBgsJCAcDAgYVCAIJ
 CgsEFgIDAQIeAQIXgAUCTo3k0QIZAQAKCRBoNZUwcMmSsMO2D/421Xg8pimb9mPzM5N7khT0
 2MCnaGssU1T59YPE25kYdx2HntwdO0JA27Wn9xx5zYijOe6B21ufrvsyv42auCO85+oFJWfE
 K2R/IpLle09GDx5tcEmMAHX6KSxpHmGuJmUPibHVbfep2aCh9lKaDqQR07gXXWK5/yU1Dx0r
 VVFRaHTasp9fZ9AmY4K9/BSA3VkQ8v3OrxNty3OdsrmTTzO91YszpdbjjEFZK53zXy6tUD2d
 e1i0kBBS6NLAAsqEtneplz88T/v7MpLmpY30N9gQU3QyRC50jJ7LU9RazMjUQY1WohVsR56d
 ORqFxS8ChhyJs7BI34vQusYHDTp6PnZHUppb9WIzjeWlC7Jc8lSBDlEWodmqQQgp5+6AfhTD
 kDv1a+W5+ncq+Uo63WHRiCPuyt4di4/0zo28RVcjtzlGBZtmz2EIC3vUfmoZbO/Gn6EKbYAn
 rzz3iU/JWV8DwQ+sZSGu0HmvYMt6t5SmqWQo/hyHtA7uF5Wxtu1lCgolSQw4t49ZuOyOnQi5
 f8R3nE7lpVCSF1TT+h8kMvFPv3VG7KunyjHr3sEptYxQs4VRxqeirSuyBv1TyxT+LdTm6j4a
 mulOWf+YtFRAgIYyyN5YOepDEBv4LUM8Tz98lZiNMlFyRMNrsLV6Pv6SxhrMxbT6TNVS5D+6
 UorTLotDZKp5+M7BTQRUY85qARAAsgMW71BIXRgxjYNCYQ3Xs8k3TfAvQRbHccky50h99TUY
 sqdULbsb3KhmY29raw1bgmyM0a4DGS1YKN7qazCDsdQlxIJp9t2YYdBKXVRzPCCsfWe1dK/q
 66UVhRPP8EGZ4CmFYuPTxqGY+dGRInxCeap/xzbKdvmPm01Iw3YFjAE4PQ4hTMr/H76KoDbD
 cq62U50oKC83ca/PRRh2QqEqACvIH4BR7jueAZSPEDnzwxvVgzyeuhwqHY05QRK/wsKuhq7s
 UuYtmN92Fasbxbw2tbVLZfoidklikvZAmotg0dwcFTjSRGEg0Gr3p/xBzJWNavFZZ95Rj7Et
 db0lCt0HDSY5q4GMR+SrFbH+jzUY/ZqfGdZCBqo0cdPPp58krVgtIGR+ja2Mkva6ah94/oQN
 lnCOw3udS+Eb/aRcM6detZr7XOngvxsWolBrhwTQFT9D2NH6ryAuvKd6yyAFt3/e7r+HHtkU
 kOy27D7IpjngqP+b4EumELI/NxPgIqT69PQmo9IZaI/oRaKorYnDaZrMXViqDrFdD37XELwQ
 gmLoSm2VfbOYY7fap/AhPOgOYOSqg3/Nxcapv71yoBzRRxOc4FxmZ65mn+q3rEM27yRztBW9
 AnCKIc66T2i92HqXCw6AgoBJRjBkI3QnEkPgohQkZdAb8o9WGVKpfmZKbYBo4pEAEQEAAcLB
 XwQYAQIACQUCVGPOagIbDAAKCRBoNZUwcMmSsJeCEACCh7P/aaOLKWQxcnw47p4phIVR6pVL
 e4IEdR7Jf7ZL00s3vKSNT+nRqdl1ugJx9Ymsp8kXKMk9GSfmZpuMQB9c6io1qZc6nW/3TtvK
 pNGz7KPPtaDzvKA4S5tfrWPnDr7n15AU5vsIZvgMjU42gkbemkjJwP0B1RkifIK60yQqAAlT
 YZ14P0dIPdIPIlfEPiAWcg5BtLQU4Wg3cNQdpWrCJ1E3m/RIlXy/2Y3YOVVohfSy+4kvvYU3
 lXUdPb04UPw4VWwjcVZPg7cgR7Izion61bGHqVqURgSALt2yvHl7cr68NYoFkzbNsGsye9ft
 M9ozM23JSgMkRylPSXTeh5JIK9pz2+etco3AfLCKtaRVysjvpysukmWMTrx8QnI5Nn5MOlJj
 1Ov4/50JY9pXzgIDVSrgy6LYSMc4vKZ3QfCY7ipLRORyalFDF3j5AGCMRENJjHPD6O7bl3Xo
 4DzMID+8eucbXxKiNEbs21IqBZbbKdY1GkcEGTE7AnkA3Y6YB7I/j9mQ3hCgm5muJuhM/2Fr
 OPsw5tV/LmQ5GXH0JQ/TZXWygyRFyyI2FqNTx4WHqUn3yFj8rwTAU1tluRUYyeLy0ayUlKBH
 ybj0N71vWO936MqP6haFERzuPAIpxj2ezwu0xb1GjTk4ynna6h5GjnKgdfOWoRtoWndMZxbA
 z5cecg==
Message-ID: <16b26a00-eb6b-7c19-6c33-144efe516b6b@intel.com>
Date:   Thu, 14 Jan 2021 10:35:03 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <YACFasdDi0siM2ML@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On 1/14/21 9:54 AM, Jarkko Sakkinen wrote:
> On Tue, Jan 12, 2021 at 04:24:01PM -0800, Dave Hansen wrote:
>> We need a bit more information here as well.  What's the relationship
>> between NUMA nodes and sections?  How does the BIOS tell us which NUMA
>> nodes a section is in?  Is it the same or different from normal RAM and
>> PMEM?
> 
> How does it go with pmem?

I just wanted to point out PMEM as being referred to by the SRAT, but as
something which is *not* "System RAM".  There might be some overlap in
NUMA for PMEM and NUMA for SGX memory since neither is enumerated as
"System RAM".

...
>> I'm not positive this works.  I *thought* these ->node_start_pfn and
>> ->node_spanned_pages are really only guaranteed to cover memory which is
>> managed by the kernel and has 'struct page' for it.
>>
>> EPC doesn't have a 'struct page', so won't necessarily be covered by the
>> pgdat-> and zone-> ranges.  I *think* you may have to go all the way
>> back to the ACPI SRAT for this.
>>
>> It would also be *possible* to have an SRAT constructed like this:
>>
>> 0->1GB System RAM - Node 0
>> 1->2GB Reserved   - Node 1
>> 2->3GB System RAM - Node 0
>>
>> Where the 1->2GB is EPC.  The Node 0 pg_data_t would be:
>>
>> 	pgdat->node_start_pfn = 0
>> 	pgdat->node_spanned_pages = 3GB
> 
> If I've understood the current Linux memory architecture correctly.
> 
> - Memory is made available through mm/memory_hotplug.c, which is populated
>   by drivers/acpi/acpi_memhotplug.c.
> - drivers/acpi/numa/srat.c provides the conversion API from proximity node to
>   logical node but I'm not *yet* sure how the interaction goes with memory
>   hot plugging
> 
> I'm not sure of I'm following the idea of alternative SRAT construciton.
> So are you saying that srat.c would somehow group pxm's with EPC to
> specific node numbers?

Basically, go look at the "SRAT:" messages in boot.  Are there SRAT
entries that cover all the EPC?  For instance, take this SRAT:

[    0.000000] ACPI: SRAT: Node 1 PXM 2 [mem 0x00000000-0xcfffffff]
[    0.000000] ACPI: SRAT: Node 1 PXM 2 [mem 0x100000000-0x82fffffff]
[    0.000000] ACPI: SRAT: Node 0 PXM 1 [mem 0x830000000-0xe2fffffff]

If EPC were at 0x100000000, we would be in good shape.  It is covered by
an SRAT entry that Linux parses as RAM.  But, if it were at 0xd0000000,
it would be in an SRAT "hole", uncovered by an SRAT entry.  In this
case, since 'Node 1" spans that hole the "Node 1" pgdat would span this
hole.  But, if some memory was removed from the system, "Node 1" might
no longer span that hole and EPC in this hole would not be assignable to
Node 1.

Please just make sure that there *ARE* SRAT entries that cover EPC
memory ranges.
